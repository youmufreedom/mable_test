# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :payer_transactions, class_name: 'Transaction', foreign_key: 'payer_id'
  has_many :payee_transactions, class_name: 'Transaction', foreign_key: 'payee_id'

  validates :account_number, numericality: { only_integer: true }, length: { is: 16 }, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
