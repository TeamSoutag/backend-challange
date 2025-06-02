# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    balance { Faker::Number.decimal(l_digits: 3) }
    association :user
  end
end
