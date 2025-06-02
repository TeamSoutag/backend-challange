# frozen_string_literal: true

class GasStation < ApplicationRecord
  # Associations
  belongs_to :address, inverse_of: :gas_station
  has_many :gas_station_products, inverse_of: :gas_station, dependent: :destroy
  has_many :products, through: :gas_station_products
  has_many :refuelings, inverse_of: :gas_station, dependent: :destroy

  # Validators
  validates :name, presence: true
  validates :address_id, uniqueness: true

  # Nested attributes
  accepts_nested_attributes_for :address
end

# == Schema Information
#
# Table name: gas_stations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_gas_stations_on_address_id  (address_id) UNIQUE
#
# Foreign Keys
#
#  address_id  (address_id => addresses.id)
#
