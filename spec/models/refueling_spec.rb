# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Refueling, type: :model do
  describe 'associations' do
    it { should belong_to(:user).inverse_of(:refuelings) }
    it { should belong_to(:gas_station).inverse_of(:refuelings) }
    it { should belong_to(:product).inverse_of(:refuelings) }
  end

  describe 'validations' do
    subject { build(:refueling) }

    it { should validate_presence_of(:liters) }
    it { should validate_numericality_of(:liters).is_greater_than(0) }

    it { should validate_presence_of(:total_price) }
    it { should validate_numericality_of(:total_price).is_greater_than(0) }

    it { should validate_presence_of(:discount_applied) }
    it { should validate_presence_of(:product_id) }
  end
end
