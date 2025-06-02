# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefuelingServices::PriceCalculator do
  describe '#calculate' do
    let(:product_id) { 1 }
    let(:gas_station_id) { 2 }
    let(:liters) { 10.0 }
    let(:price_per_liter) { 5.5 }
    let(:product_discount_key) { :gasoline }
    let(:product_discount_value) { 0.02 } # Actual value from Discounts enum

    let(:product) { instance_double(Product, id: product_id, discount: product_discount_key) }
    let(:gas_station) { instance_double(GasStation, id: gas_station_id) }
    let(:gas_station_product) do
      instance_double(GasStationProduct,
                      price_per_liter: price_per_liter,
                      product_id: product_id,
                      gas_station_id: gas_station_id)
    end

    subject { described_class.new(liters: liters, product: product, gas_station: gas_station) }

    context 'when gas station product is found' do
      before do
        allow(GasStationProduct).to receive(:find_by).with(
          product_id: product_id,
          gas_station_id: gas_station_id
        ).and_return(gas_station_product)

          # Stub Discounts.discount_for to return a known value for our tests
          allow(Discounts).to receive(:discount_for).with(product_discount_key).and_return(product_discount_value)
        end

      it 'calculates prices correctly' do
        expected_base_price = price_per_liter
        expected_base_total = liters * expected_base_price

        expected_fixed_discount = expected_base_total * 0.05
        expected_product_discount = expected_base_total * product_discount_value
        expected_discount_applied = (expected_fixed_discount + expected_product_discount).round(2)
        expected_total_price = (expected_base_total - expected_discount_applied).round(2)

        result = subject.calculate

        expect(result[:base_price]).to eq(expected_base_price.round(2))
        expect(result[:base_total]).to eq(expected_base_total.round(2))
        expect(result[:discount_applied]).to eq(expected_discount_applied)
        expect(result[:total_price]).to eq(expected_total_price)
      end

      it 'rounds all monetary values to 2 decimal places' do
        # Use a price value that will generate a discount that needs proper rounding
        allow(gas_station_product).to receive(:price_per_liter).and_return(5.567)

        # Force the discount to have a specific value that needs formatting
        allow(Discounts).to receive(:discount_for).with(product_discount_key).and_return(0.0234)

        result = subject.calculate

        # Check that all monetary values have exactly 2 decimal places
        expect(result[:base_price].to_s).to match(/\A\d+\.\d{2}\z/)
        expect(result[:base_total].to_s).to match(/\A\d+\.\d{2}\z/)
        expect(result[:discount_applied].to_s).to match(/\A\d+\.\d{2}\z/)
        expect(result[:total_price].to_s).to match(/\A\d+\.\d{2}\z/)

        # Specifically check that the discount is properly formatted
        expect(sprintf("%.2f", result[:discount_applied])).to eq(sprintf("%.2f", result[:discount_applied].round(2)))
      end

      it 'calls Discounts.discount_for with the product discount key' do
        expect(Discounts).to receive(:discount_for).with(product_discount_key)
        subject.calculate
      end
    end

    context 'when gas station product is not found' do
      before do
        allow(GasStationProduct).to receive(:find_by).with(
          product_id: product_id,
          gas_station_id: gas_station_id
        ).and_return(nil)
      end

      it 'raises ActiveRecord::RecordNotFound with an appropriate message' do
        expected_error_message = 'Price not found for this product at the selected gas station'

        expect { subject.calculate }.to raise_error(ActiveRecord::RecordNotFound, expected_error_message)
      end
    end

    context 'with various discount combinations' do
      before do
        allow(GasStationProduct).to receive(:find_by).with(
          product_id: product_id,
          gas_station_id: gas_station_id
        ).and_return(gas_station_product)
      end

      it 'calculates correctly with diesel (zero product discount)' do
        # Use diesel which has 0.0 discount according to the Discounts enum
        diesel_product = instance_double(Product, id: product_id, discount: :diesel)
        diesel_calculator = described_class.new(liters: liters, product: diesel_product, gas_station: gas_station)

        # Stub the Discounts.discount_for call for diesel
        allow(Discounts).to receive(:discount_for).with(:diesel).and_return(0.0)

        result = diesel_calculator.calculate

        # Only the fixed 5% discount should apply
        expected_discount = (liters * price_per_liter * 0.05).round(2)
        expect(result[:discount_applied]).to eq(expected_discount)
      end

      it 'calculates correctly with different product types' do
        # Test with alcohol (1% discount)
        alcohol_product = instance_double(Product, id: product_id, discount: :alcohol)
        alcohol_calculator = described_class.new(liters: liters, product: alcohol_product, gas_station: gas_station)

        # Stub the Discounts.discount_for call for alcohol
        allow(Discounts).to receive(:discount_for).with(:alcohol).and_return(0.01)

        result = alcohol_calculator.calculate

        # Fixed 5% + alcohol 1% = 6% total discount
        expected_discount = (liters * price_per_liter * (0.05 + 0.01)).round(2)
        expect(result[:discount_applied]).to eq(expected_discount)
      end
    end
  end
end
