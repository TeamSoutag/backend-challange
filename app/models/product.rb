# frozen_string_literal: true

class Product < ApplicationRecord
  # Associations
  has_many :gas_station_products, dependent: :destroy, inverse_of: :product
  has_many :gas_stations, through: :gas_station_products
  has_many :refuelings, dependent: :destroy, inverse_of: :product

  # Enums
  has_enumeration_for :discount, with: Discounts, create_helpers: { prefix: true }

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :discount, presence: true

  # Nested attributes
  accepts_nested_attributes_for :gas_station_products,
                                allow_destroy: true,
                                reject_if: :all_blank
end

# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  discount   :integer          not null, default(0), not null
#
