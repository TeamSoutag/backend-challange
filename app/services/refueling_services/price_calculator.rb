# frozen_string_literal: true

module RefuelingServices
  class PriceCalculator
    def initialize(liters:, product:, gas_station:)
      @liters = liters
      @product = product
      @gas_station = gas_station
    end

    def calculate
      price_per_liter = find_price_per_liter
      base_price = price_per_liter
      base_total = @liters * base_price

      fixed_discount = base_total * 0.05

      product_key = @product.discount
      product_discount = base_total * Discounts.discount_for(product_key)

      discount_applied = (fixed_discount + product_discount).round(2)
      total_price = (base_total - discount_applied).round(2)

      {
        base_price: base_price.round(2),
        base_total: base_total.round(2),
        discount_applied: discount_applied,
        total_price: total_price
      }
    end

    private

    def find_price_per_liter
      gas_station_product = GasStationProduct.find_by(
        product_id: @product.id,
        gas_station_id: @gas_station.id
      )

      unless gas_station_product
        raise ActiveRecord::RecordNotFound,
              'Price not found for this product at the selected gas station'
      end

      gas_station_product.price_per_liter
    end
  end
end
