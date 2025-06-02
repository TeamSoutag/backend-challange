# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { should belong_to(:user).inverse_of(:wallet) }
  end

  describe 'validations' do
    subject { build(:wallet) }

    it { should validate_presence_of(:balance) }
    it { should validate_numericality_of(:balance).is_greater_than(0).with_message('must be greater than zero') }
  end
end
