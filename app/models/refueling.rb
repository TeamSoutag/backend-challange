# frozen_string_literal: true

class Refueling < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :refuelings
  belongs_to :gas_station, inverse_of: :refuelings
  belongs_to :product, inverse_of: :refuelings

  # Validations
  validates :liters, :total_price, :discount_applied, :product_id, presence: true
  validates :liters, numericality: { greater_than: 0 }
  validates :total_price, numericality: { greater_than: 0 }
end

# == Schema Information
#
# Table name: refuelings
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  gas_station_id   :integer          not null
#  product_id       :integer          not null
#  liters           :decimal(10, 2)   not null
#  total_price      :decimal(10, 2)   not null
#  discount_applied :decimal(5, 2)    not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_refuelings_on_gas_station_id  (gas_station_id)
#  index_refuelings_on_product_id      (product_id)
#  index_refuelings_on_user_id         (user_id)
#
# Foreign Keys
#
#  gas_station_id  (gas_station_id => gas_stations.id)
#  product_id      (product_id => product.id)
#  user_id         (user_id => users.id)
#
