# frozen_string_literal: true

FactoryBot.define do
  factory :refueling do
    association :user
    association :gas_station
    association :product

    liters { Faker::Number.decimal(l_digits: 2) }
    discount_applied { 0 }
    total_price { Faker::Number.decimal(l_digits: 2) }

    before(:create) do |refueling|
      # Ensure gas_station_product exists
      unless GasStationProduct.exists?(gas_station: refueling.gas_station, product: refueling.product)
        create(:gas_station_product,
               gas_station: refueling.gas_station,
               product: refueling.product,
               price_per_liter: 5.0)
      end
    end

    trait :with_custom_price do
      transient do
        unit_price { 2.0 }
      end

      before(:create) do |refueling, evaluator|
        refueling.total_price = (
          refueling.liters * evaluator.unit_price * (1 - refueling.discount_applied / 100.0)).round(2)
      end
    end
  end
end
