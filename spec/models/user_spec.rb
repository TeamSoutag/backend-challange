# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:wallet).dependent(:destroy) }
    it { should have_many(:refuelings).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    context 'email format validation' do
      it 'accepts valid email formats' do
        valid_emails = ['user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org']
        valid_emails.each do |valid_email|
          user = build(:user, email: valid_email)
          expect(user).to be_valid
        end
      end

      it 'rejects invalid email formats' do
        invalid_emails = ['user@example,com', 'user_at_foo.org', 'user.name@example.', 'foo@bar_baz.com']
        invalid_emails.each do |invalid_email|
          user = build(:user, email: invalid_email)
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include('is invalid')
        end
      end

      it 'uses URI::MailTo::EMAIL_REGEXP for validation' do
        user_class = User.validators_on(:email).find { |v| v.is_a?(ActiveModel::Validations::FormatValidator) }
        expect(user_class.options[:with]).to eq(URI::MailTo::EMAIL_REGEXP)
      end
    end
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:wallet).allow_destroy(true) }

    context 'when creating a user with wallet attributes' do
      let(:user) { build(:user, wallet_attributes: { balance: 100.0 }) }

      it 'builds a wallet with the specified balance' do
        expect(user.wallet.balance).to eq(100.0)
      end

      it 'persists the wallet when the user is saved' do
        expect { user.save }.to change(Wallet, :count).by(1)
        expect(user.wallet).to be_persisted
        expect(user.wallet.balance).to eq(100.0)
      end
    end

    context 'when updating a user with wallet attributes' do
      let(:user) { create(:user, wallet_attributes: { balance: 100.0 }) }

      it 'updates the wallet with the new balance' do
        user.update(wallet_attributes: { balance: 200.0 })
        expect(user.reload.wallet.balance).to eq(200.0)
      end
    end
  end
end
