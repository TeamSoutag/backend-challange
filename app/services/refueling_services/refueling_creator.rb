# frozen_string_literal: true

module RefuelingServices
  class RefuelingCreator
    def initialize(user_id:, gas_station:, product:, liters:)
      @user_id = user_id
      @gas_station = gas_station
      @product = product
      @liters = liters
      @wallet_service = initialize_wallet_service
    end

    def execute
      validate_balance
      create_refueling_transaction
    end

    private

    def initialize_wallet_service
      wallet = find_user_wallet
      ::WalletServices::Debit.new(wallet)
    rescue ActiveRecord::RecordNotFound
      record = User.new
      record.errors.add(:base, 'User not found')
      raise ActiveRecord::RecordInvalid.new(record)
    end

    def find_user_wallet
      User.find(@user_id).wallet
    end

    def validate_balance
      prices = calculate_prices
      return if @wallet_service.sufficient_balance?(prices[:total_price])

      record = Refueling.new
      record.errors.add(:base, 'Insufficient balance')
      raise ActiveRecord::RecordInvalid.new(record)
    end

    def calculate_prices
      PriceCalculator.new(
        liters: @liters,
        product: @product,
        gas_station: @gas_station
      ).calculate
    end

    def create_refueling_transaction
      prices = calculate_prices

      Refueling.transaction do
        refueling = Refueling.create!(
          user_id: @user_id,
          gas_station_id: @gas_station.id,
          product_id: @product.id,
          liters: @liters,
          total_price: prices[:total_price],
          discount_applied: prices[:discount_applied]
        )

        @wallet_service.debit(prices[:total_price])

        refueling
      end
    end
  end
end
