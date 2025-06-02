# frozen_string_literal: true

module WalletServices
  class Debit
    def initialize(wallet)
      @wallet = wallet
    end

    def sufficient_balance?(amount)
      @wallet.balance >= amount
    end

    def debit(amount)
      raise 'Insufficient Balance' unless sufficient_balance?(amount)

      @wallet.update!(balance: @wallet.balance - amount)
    end
  end
end
