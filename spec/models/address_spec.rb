# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:gas_station).inverse_of(:address) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:acronym) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip_code) }

    context 'when validating zip_code format' do
      it 'accepts valid format' do
        address = build(:address, zip_code: '12345-678')
        address.valid?
        expect(address.errors[:zip_code]).to be_empty
      end

      it 'rejects invalid formats' do
        invalid_formats = %w[12345 1234-678 123456-78 12345-67 123456789]

        invalid_formats.each do |format|
          address = build(:address, zip_code: format)
          address.valid?
          expect(address.errors[:zip_code]).to include('must be in the format XXXXX-XXX')
        end
      end
    end
  end

  describe 'enumerations' do
    it 'defines the AddressAcronym enumeration' do
      address = build(:address)
      expect(address.respond_to?(:acronym)).to be true
      expect(address.respond_to?(:acronym_humanize)).to be true
      expect(address.respond_to?(:acronym_avenue?)).to be true
      expect(address.respond_to?(:acronym_street?)).to be true
      expect(address.respond_to?(:acronym_square?)).to be true
    end

    it 'creates helpers for acronym values' do
      address = build(:address, acronym: AddressAcronym::AVENUE)

      expect(address.acronym_avenue?).to be true
      expect(address.acronym_street?).to be false
      expect(address.acronym_square?).to be false
    end

    it 'allows setting valid acronym values' do
      address = build(:address)

      AddressAcronym.list.each do |value|
        address.acronym = value
        expect(address).to be_valid
      end
    end
  end
end
