# frozen_string_literal: true

class Address < ApplicationRecord
  # Associations
  has_one :gas_station, inverse_of: :address

  # Enum to choose the address acronym
  has_enumeration_for :acronym, with: AddressAcronym, create_helpers: { prefix: true }

  # validators
  validates :acronym, :street, :number, :city, :state, :zip_code, presence: true
  validates :zip_code, format: { with: /\A\d{5}-\d{3}\z/, message: 'must be in the format XXXXX-XXX' }
end

# == Schema Information
#
# Table name: addresses
#
#  id             :integer          not null, primary key
#  street         :string
#  street_details :string
#  number         :string
#  city           :string
#  state          :string
#  zip_code       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  acronym        :integer
#
