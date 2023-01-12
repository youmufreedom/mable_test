# frozen_string_literal: true

class AccountCsvImportService
  require 'csv'

  class AccountCreateError < StandardError; end

  def call(file)
    opened_file = File.open(file)
    options = { headers: false, col_sep: ',' }

    ActiveRecord::Base.transaction do
      CSV.foreach(opened_file, **options) do |row|
        account_hash = {}
        account_hash[:account_number] = row[0]
        account_hash[:balance] = row[1]

        Account.find_or_create_by(account_hash)
      end
    end
  rescue ActiveRecord::RecordInvalid
    raise AccountCreateError, 'Oops. Input file data invalid!'
  rescue ActiveRecord::RecordNotUnique
    raise AccountCreateError, 'Oops, Account already exists'
  end
end
