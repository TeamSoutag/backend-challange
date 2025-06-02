# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }

    wallet_attributes { attributes_for(:wallet) }

    trait :with_custom_wallet_balance do
      transient do
        custom_balance { Faker::Number.decimal(l_digits: 3) }
      end

      wallet_attributes { { balance: custom_balance } }
    end

    factory :user_with_custom_balance do
      with_custom_wallet_balance
    end
  end
end
