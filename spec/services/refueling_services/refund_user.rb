# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefuelingServices::RefundUser do
  describe '#execute' do
    let(:user) { create(:user) }
    let(:initial_balance) { user.wallet.balance }
    let(:refueling) { create(:refueling, user: user) }
    let(:expected_refund) { refueling.total_price }

    context 'when successful' do
      it 'destroys the refueling and refunds the exact total_price' do
        service = described_class.new(refueling)

        expect { service.execute }
          .to change(Refueling, :count).by(-1)
          .and change { user.wallet.reload.balance }
          .from(initial_balance)
          .to(initial_balance + expected_refund)

        expect(service.execute).to be true
      end
    end

    context 'when calculations include discounts' do
      let(:refueling) do
        create(:refueling, :with_custom_price,
               user: user,
               liters: 50,
               unit_price: 2.0,
               discount_applied: 10.0)
      end

      it 'refunds the correct discounted amount' do
        service = described_class.new(refueling)
        calculated_total = ((50 * 2.0) * (1 - 10.0 / 100)).round(2)

        expect(refueling.total_price.round(2)).to eq(calculated_total)

        initial_rounded_balance = user.wallet.balance.round(2)
        service.execute
        final_rounded_balance = user.wallet.reload.balance.round(2)

        expect(final_rounded_balance - initial_rounded_balance).to eq(calculated_total)
      end
    end

    context 'when refueling destruction fails' do
      before do
        allow(refueling).to receive(:destroy!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'does not change the balance' do
        service = described_class.new(refueling)

        expect { service.execute }
          .not_to(change { user.wallet.reload.balance })
      end
    end
  end
end
