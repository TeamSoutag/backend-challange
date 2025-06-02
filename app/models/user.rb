# frozen_string_literal: true

class User < ApplicationRecord
  # Associations
  has_one :wallet, inverse_of: :user, dependent: :destroy
  has_many :refuelings, inverse_of: :user, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :wallet, allow_destroy: true

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  users_email_index  (email) UNIQUE
#
