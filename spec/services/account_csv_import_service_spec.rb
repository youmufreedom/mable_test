# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe AccountCsvImportService do
  let(:row1) { '1111234522226789, 5000.00' }
  let(:row2) { '1111234522221234, 10000.00' }

  let(:rows) { [row1, row2] }

  let(:test_csv_path) { 'tmp/test.csv' }
  let!(:csv) do
    CSV.open(test_csv_path, 'w') do |csv|
      rows.each do |row|
        csv << row.split(', ')
      end
    end
  end

  subject(:import) { AccountCsvImportService.call(test_csv_path) }

  after(:each) { File.delete(test_csv_path) }

  describe '#call' do
    context 'correct data input' do
      it 'imports validated csv file successfully' do
        expect { import }.to change { Account.count }.from(0).to(2)
        expect(Account.where(account_number: '1111234522226789').count).to eq 1
        expect(Account.find_by(account_number: '1111234522226789').balance).to eq 5000.00
        expect(Account.where(account_number: '1111234522221234').count).to eq 1
        expect(Account.find_by(account_number: '1111234522221234').balance).to eq 10000.00
      end
    end

    context 'wrong account number input' do
      let(:row2) { '11112345222214, 10000.00' }
      it 'imports invalidated csv file failed' do
        expect { import }.to raise_error(AccountCsvImportService::AccountCreateError)
      end
    end

    context 'wrong account number data type input' do
      let(:row2) { 'asdf, 10000.00' }
      it 'imports invalidated csv file failed' do
        expect { import }.to raise_error(AccountCsvImportService::AccountCreateError)
      end
    end

    context 'wrong balance input' do
      let(:row2) { '1111234522221234, -10000.00' }
      it 'imports invalidated csv file failed' do
        expect { import }.to raise_error(AccountCsvImportService::AccountCreateError)
      end
    end

    context 'wrong balance data type input' do
      let(:row2) { '11112345222214, asdf' }
      it 'imports invalidated csv file failed' do
        expect { import }.to raise_error(AccountCsvImportService::AccountCreateError)
      end
    end

    context 'new account imports' do
      let(:new_row3) { '2222123433331212, 550.00' }
      let(:new_rows) { [new_row3] }

      let(:new_test_csv_path) { 'tmp/new_test.csv' }
      let!(:csv1) do
        CSV.open(new_test_csv_path, 'w') do |csv|
          new_rows.each do |row|
            csv << row.split(',')
          end
        end
      end

      subject(:new_import) { AccountCsvImportService.call(new_test_csv_path) }

      after(:each) { File.delete(new_test_csv_path) }

      it 'imports new validated csv file successfully' do
        expect { import }.to change { Account.count }.from(0).to(2)
        expect { new_import }.to change { Account.count }.from(2).to(3)
        expect(Account.where(account_number: '2222123433331212').count).to eq 1
        expect(Account.find_by(account_number: '2222123433331212').balance).to eq 550.00
      end
    end

    context 'new duplicated account imports' do
      let(:new_row3) { '1111234522226789, 550.00' }
      let(:new_rows) { [new_row3] }

      let(:new_test_csv_path) { 'tmp/new_test.csv' }
      let!(:csv1) do
        CSV.open(new_test_csv_path, 'w') do |csv|
          new_rows.each do |row|
            csv << row.split(',')
          end
        end
      end

      subject(:new_import) { AccountCsvImportService.call(new_test_csv_path) }

      after(:each) { File.delete(new_test_csv_path) }

      it 'imports failed' do
        expect { import }.to change { Account.count }.from(0).to(2)
        expect { new_import }.to raise_error(AccountCsvImportService::AccountCreateError)
      end
    end
  end
end
