# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GasStationProduct, type: :model do
  describe 'associations' do
    it { should belong_to(:gas_station).inverse_of(:gas_station_products) }
    it { should belong_to(:product).inverse_of(:gas_station_products) }
  end

  describe 'validations' do
    subject { build(:gas_station_product) }

    it { should validate_presence_of(:price_per_liter) }
    it { should validate_numericality_of(:price_per_liter).is_greater_than(0) }
  end
end
