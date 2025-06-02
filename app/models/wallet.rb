# frozen_string_literal: true

class Wallet < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :wallet

  # Validators
  validates :balance, presence: true
  validates :balance, numericality: { greater_than: 0, message: 'must be greater than zero' }
end

# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  balance    :float
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_wallets_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
