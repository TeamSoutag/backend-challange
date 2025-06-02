# frozen_string_literal: true

class GasStationProduct < ApplicationRecord
  # Associations
  belongs_to :gas_station, inverse_of: :gas_station_products
  belongs_to :product, inverse_of: :gas_station_products

  # Validators
  validates :price_per_liter, presence: true, numericality: { greater_than: 0 }
end

# == Schema Information
#
# Table name: gas_station_products
#
#  id              :integer          not null, primary key
#  gas_station_id  :integer          not null
#  product_id      :integer          not null
#  price_per_liter :float            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_gas_station_products_on_gas_station_id  (gas_station_id)
#  index_gas_station_product_on_products_id     (product_id)
#
# Foreign Keys
#
#  gas_station_id  (gas_station_id => gas_stations.id)
#  product_id      (product_id => products.id)
#
