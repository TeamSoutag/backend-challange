# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefuelingServices::RefuelingCreator do
  describe '#execute' do
    let(:user) { instance_double(User) }
    let(:wallet) { instance_double(Wallet) }
    let(:gas_station) { instance_double(GasStation, id: 1) }
    let(:product) { instance_double(Product, id: 2) }
    let(:liters) { 20.0 }
    let(:user_id) { 1 }
    let(:total_price) { 100.0 }
    let(:discount_applied) { 10.0 }
    let(:price_calculation_result) do
      {
        total_price: total_price,
        discount_applied: discount_applied
      }
    end
    let(:wallet_service) { instance_double(WalletServices::Debit) }
    let(:price_calculator) { instance_double(::RefuelingServices::PriceCalculator) }

    before do
      allow(User).to receive(:find).with(user_id).and_return(user)
      allow(user).to receive(:wallet).and_return(wallet)
      allow(WalletServices::Debit).to receive(:new).with(wallet).and_return(wallet_service)
      allow(::RefuelingServices::PriceCalculator).to receive(:new).with(
        liters: liters,
        product: product,
        gas_station: gas_station
      ).and_return(price_calculator)
      allow(price_calculator).to receive(:calculate).and_return(price_calculation_result)
    end

    subject { described_class.new(user_id: user_id, gas_station: gas_station, product: product, liters: liters) }

    context 'when successful' do
      let(:refueling) { instance_double(Refueling, id: 1) }

      before do
        allow(wallet_service).to receive(:sufficient_balance?).with(total_price).and_return(true)
        allow(wallet_service).to receive(:debit).with(total_price)
        allow(Refueling).to receive(:transaction).and_yield
        allow(Refueling).to receive(:create!).with(
          user_id: user_id,
          gas_station_id: gas_station.id,
          product_id: product.id,
          liters: liters,
          total_price: total_price,
          discount_applied: discount_applied
        ).and_return(refueling)
      end

      it 'creates a refueling record' do
        expect(Refueling).to receive(:create!).with(
          user_id: user_id,
          gas_station_id: gas_station.id,
          product_id: product.id,
          liters: liters,
          total_price: total_price,
          discount_applied: discount_applied
        )

        result = subject.execute

        expect(result).to eq(refueling)
      end

      it 'debits the wallet' do
        expect(wallet_service).to receive(:debit).with(total_price)

        subject.execute
      end

      it 'calculates the price using PriceCalculator' do
        expect(price_calculator).to receive(:calculate)

        subject.execute
      end
    end

    context 'when balance is insufficient' do
      let(:refueling) { Refueling.new }

      before do
        allow(wallet_service).to receive(:sufficient_balance?).with(total_price).and_return(false)
        allow(Refueling).to receive(:new).and_return(refueling)
      end

      it 'raises RecordInvalid error with insufficient balance message' do
        expect { subject.execute }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create a refueling record' do
        expect(Refueling).not_to receive(:create!)

        expect { subject.execute }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not debit the wallet' do
        expect(wallet_service).not_to receive(:debit)

        expect { subject.execute }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when user is not found' do
      let(:user_record) { User.new }

      before do
        allow(User).to receive(:find).with(user_id).and_raise(ActiveRecord::RecordNotFound)
        allow(User).to receive(:new).and_return(user_record)
      end

      it 'raises RecordInvalid error with user not found message' do
        expect { subject.execute }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create a refueling record' do
        expect(Refueling).not_to receive(:create!)

        expect { subject.execute }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not debit the wallet' do
        expect(wallet_service).not_to receive(:debit)

        expect { subject.execute }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
