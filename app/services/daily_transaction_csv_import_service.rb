# frozen_string_literal: true

class DailyTransactionCsvImportService
  require 'csv'

  class TransactionCreateError < StandardError; end

  def call(file)
    opened_file = File.open(file)
    options = { headers: false, col_sep: ',' }

    ActiveRecord::Base.transaction do
      CSV.foreach(opened_file, **options).with_index do |row, i|
        create_transaction(row[0], row[1], row[2].to_d, i + 1)
      end
    end
  rescue ActiveRecord::RecordInvalid
    raise TransactionCreateError, 'Oops. Input file data invalid!'
  end

  def create_transaction(payer_account_number, payee_account_number, amount, line)
    payer = Account.find_by(account_number: payer_account_number)
    raise TransactionCreateError, "Oops. Line #{line} Payer not exist!" unless payer

    payee = Account.find_by(account_number: payee_account_number)
    raise TransactionCreateError, "Oops. Line #{line} Payer not exist!" unless payee

    raise TransactionCreateError, "Oops, Please correct Line #{line} amount" unless amount.positive?
    raise TransactionCreateError, "Oops, Line #{line} Payer insufficient balance" if payer.balance < amount

    Transaction.create(payer: payer, payee: payee, amount: amount)
    update_account_balance(payer, payee, amount)
  end

  def update_account_balance(payer, payee, amount)
    payer.update(balance: payer.balance - amount)
    payee.update(balance: payee.balance + amount)
  end
end
