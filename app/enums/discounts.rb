# frozen_string_literal: true

class Discounts < EnumerateIt::Base
  associate_values(
    gasoline: [0, 'Gasoline'],
    alcohol: [1, 'Alcohol'],
    diesel: [2, 'Diesel']
  )

  DISCOUNT_VALUES = {
    gasoline: 0.02,
    alcohol: 0.01,
    diesel: 0.0
  }.freeze

  def self.discount_for(key)
    DISCOUNT_VALUES[key] || 0.0
  end
end
