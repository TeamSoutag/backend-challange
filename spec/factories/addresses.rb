# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    acronym { AddressAcronym::AVENUE }
    street { Faker::Address.street_name }
    street_details { nil }
    number { Faker::Address.building_number }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { "#{Faker::Number.number(digits: 5)}-#{Faker::Number.number(digits: 3)}" }

    trait :with_details do
      street_details { 'Building A, Apt 101' }
    end

    trait :avenue do
      acronym { AddressAcronym::AVENUE }
    end

    trait :street do
      acronym { AddressAcronym::STREET }
    end

    trait :square do
      acronym { AddressAcronym::SQUARE }
    end
  end
end
