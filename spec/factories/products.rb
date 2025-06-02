# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Gasoline' }
    discount { Discounts::GASOLINE }

    transient do
      gas_station { create(:gas_station) }
      price_per_liter { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    end

    after(:build) do |product, evaluator|
      product.gas_station_products_attributes = [{
        gas_station_id: evaluator.gas_station.id,
        price_per_liter: evaluator.price_per_liter
      }]
    end

    trait :gasoline do
      name { 'Gasoline' }
      discount { Discounts::GASOLINE }
    end

    trait :alcohol do
      name { 'Alcohol' }
      discount { Discounts::ALCOHOL }
    end

    trait :diesel do
      name { 'Diesel S10' }
      discount { Discounts::DIESEL }
    end
  end
end
