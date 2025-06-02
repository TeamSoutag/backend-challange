# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalletServices::Debit do
  let(:wallet) { instance_double('Wallet', balance: 100) }
  let(:service) { described_class.new(wallet) }

  describe '#sufficient_balance?' do
    context 'when balance is sufficient' do
      it 'returns true' do
        expect(service.sufficient_balance?(50)).to be true
      end
    end

    context 'when balance is insufficient' do
      it 'returns false' do
        expect(service.sufficient_balance?(150)).to be false
      end
    end
  end

  describe '#debit' do
    context 'when balance is sufficient' do
      it 'debits the amount from the wallet' do
        amount = 50
        expect(wallet).to receive(:update!).with(balance: 50)

        service.debit(amount)
      end
    end

    context 'when balance is insufficient' do
      it 'raises an error' do
        amount = 150

        expect do
          service.debit(amount)
        end.to raise_error('Insufficient Balance')
      end
    end
  end
end
