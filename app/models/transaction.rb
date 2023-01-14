# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :payer, class_name: 'Account'
  belongs_to :payee, class_name: 'Account'

  validates :payer, presence: true
  validates :payee, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
