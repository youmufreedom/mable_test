# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :payer_payments, class_name: 'Account', foreign_key: 'payer_id'
  has_many :payee_payments, class_name: 'Account', foreign_key: 'payee_id'

  validates :account_number, length: { is: 16 }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
