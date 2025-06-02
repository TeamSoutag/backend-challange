# frozen_string_literal: true

module RefuelingServices
  class RefundUser
    def initialize(refueling)
      @refueling = refueling
      @user = refueling.user
    end

    def execute
      ActiveRecord::Base.transaction do
        refund_amount = @refueling.total_price
        @refueling.destroy!
        refund_user_balance(refund_amount)
      end
      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    def refund_user_balance(amount)
      @user.wallet.increment!(:balance, amount)
    end
  end
end
