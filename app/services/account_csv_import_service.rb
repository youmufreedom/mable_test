# frozen_string_literal: true

class AccountCsvImportService < BaseService
  require 'csv'

  class AccountCreateError < StandardError; end

  def initialize(file)
    @file = file
  end

  def call
    opened_file = File.open(@file)
    options = { headers: false, col_sep: ',' }

    ActiveRecord::Base.transaction do
      CSV.foreach(opened_file, **options) do |row|
        account_hash = {}
        account_hash[:account_number] = row[0]
        account_hash[:balance] = row[1]
        Account.create!(account_hash)
      end
    end
  rescue ActiveRecord::RecordInvalid
    raise AccountCreateError, 'Oops. Input file data invalid!'
  rescue ActiveRecord::RecordNotUnique
    raise AccountCreateError, 'Oops, Account already exists or records duplicated'
  end
end
