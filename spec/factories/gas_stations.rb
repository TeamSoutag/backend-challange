# frozen_string_literal: true

FactoryBot.define do
  factory :gas_station do
    name { Faker::Company.name }

    address_attributes { attributes_for(:address) }
  end
end
