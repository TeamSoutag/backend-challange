# frozen_string_literal: true

FactoryBot.define do
  factory :gas_station_product do
    association :gas_station
    association :product
    price_per_liter { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end

