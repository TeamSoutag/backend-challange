# frozen_string_literal: true

class AddressAcronym < EnumerateIt::Base
  associate_values(
    street: [0, 'Street'], # Indicates the street acronym for street
    avenue: [1, 'Avenue'], # Indicates the street acronym for avenue
    square: [2, 'Square']  # Indicates the street acronym for square
  )

  def self.to_human(value)
    find_value_by_value(value).try(:name) || value
  end
end
