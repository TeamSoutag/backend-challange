# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GasStation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:address).inverse_of(:gas_station) }
    it { is_expected.to have_many(:gas_station_products).inverse_of(:gas_station).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:gas_station_products) }
    it { is_expected.to have_many(:refuelings).inverse_of(:gas_station).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    context 'uniqueness validations' do
      subject { build(:gas_station) }
      it { is_expected.to validate_uniqueness_of(:address_id) }
    end
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:address) }
  end

  describe 'relationships' do
    let(:gas_station) { create(:gas_station) }

    it 'can have multiple gas station products' do
      gasoline = create(:product, :gasoline)
      alcohol = create(:product, :alcohol)

      create(:gas_station_product, gas_station: gas_station, product: gasoline)
      create(:gas_station_product, gas_station: gas_station, product: alcohol)

      expect(gas_station.gas_station_products.count).to eq(2)
      expect(gas_station.products).to include(gasoline, alcohol)
    end

    it 'can have multiple refuelings' do
      user = create(:user)
      diesel = create(:product, :diesel)

      create(:gas_station_product, gas_station: gas_station, product: diesel)

      create(:refueling, gas_station: gas_station, product: diesel, user: user)
      create(:refueling, gas_station: gas_station, product: diesel, user: user)

      expect(gas_station.refuelings.count).to eq(2)
    end
  end
end
