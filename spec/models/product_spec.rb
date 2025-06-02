# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:gas_station_products).dependent(:destroy).inverse_of(:product) }
    it { is_expected.to have_many(:gas_stations).through(:gas_station_products) }
    it { is_expected.to have_many(:refuelings).dependent(:destroy).inverse_of(:product) }
  end

  describe 'enumerate_it' do
    it 'has correct discount enumeration keys' do
      expect(Discounts.to_a.map(&:first)).to match_array(%w[Gasoline Alcohol Diesel])
    end

    it 'has correct discount enumeration values' do
      expect(Discounts.list).to match_array([0, 1, 2])
    end

    it 'creates helper methods for each discount type' do
      product = build(:product, :gasoline)
      expect(product).to be_discount_gasoline
      expect(product).not_to be_discount_alcohol
      expect(product).not_to be_discount_diesel
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    describe 'discount validation' do
      it 'rejects nil discount' do
        product = build(:product, discount: nil)
        expect(product).not_to be_valid
        expect(product.errors[:discount]).to include("can't be blank")
      end

      it 'rejects invalid discount values' do
        product = build(:product, discount: 99)
        expect(product).not_to be_valid
        expect(product.errors[:discount]).to be_present
      end
    end

    describe 'uniqueness validations' do
      subject { build(:product) }
      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end

  describe 'relationships' do
    let(:product) { create(:product) }

    it 'can have multiple gas stations' do
      gas_station1 = create(:gas_station)
      gas_station2 = create(:gas_station)

      create(:gas_station_product, product: product, gas_station: gas_station1)
      create(:gas_station_product, product: product, gas_station: gas_station2)

      expect(product.gas_stations).to include(gas_station1, gas_station2)
    end

    it 'can have multiple refuelings' do
      user = create(:user)
      gas_station = create(:gas_station)

      create(:gas_station_product, product: product, gas_station: gas_station)

      create(:refueling, product: product, user: user, gas_station: gas_station)
      create(:refueling, product: product, user: user, gas_station: gas_station)

      expect(product.refuelings.count).to eq(2)
    end
  end
end
