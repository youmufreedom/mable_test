require 'rails_helper'

RSpec.describe DailyTransactionCsvImportService do
  let!(:account1) { Account.create(account_number: '1111234522226789', balance: 5000.00) }
  let!(:account2) { Account.create(account_number: '1111234522221234', balance: 10_000.00) }
  let!(:account3) { Account.create(account_number: '2222123433331212', balance: 550.00) }
  let!(:account4) { Account.create(account_number: '1212343433335665', balance: 1200.00) }
  let!(:account5) { Account.create(account_number: '3212343433335755', balance: 50_000.00) }

  let(:row1) { '1111234522226789, 1212343433335665, 500.00' }
  let(:row2) { '3212343433335755, 2222123433331212, 1000.00' }
  let(:row3) { '3212343433335755, 1111234522226789, 320.50' }
  let(:row4) { '1111234522221234, 1212343433335665, 25.60' }

  let(:rows) { [row1, row2, row3, row4] }

  let(:test_csv_path) { 'tmp/test.csv' }
  let!(:csv) do
    CSV.open(test_csv_path, 'w') do |csv|
      rows.each do |row|
        csv << row.split(', ')
      end
    end
  end

  subject(:import) { DailyTransactionCsvImportService.call(test_csv_path) }

  after(:each) { File.delete(test_csv_path) }

  describe '#call' do
    context 'correct data input' do
      it 'create the transaction and calculate balance successfully' do
        expect { import }.to change { Transaction.count }.from(0).to(4)
        expect(Account.where(account_number: '1111234522226789').count).to eq 1
        expect(Account.find_by(account_number: '1111234522226789').balance).to eq 4820.50

        expect(Account.where(account_number: '1111234522221234').count).to eq 1
        expect(Account.find_by(account_number: '1111234522221234').balance).to eq 9974.40

        expect(Account.where(account_number: '2222123433331212').count).to eq 1
        expect(Account.find_by(account_number: '2222123433331212').balance).to eq 1550.00

        expect(Account.where(account_number: '1212343433335665').count).to eq 1
        expect(Account.find_by(account_number: '1212343433335665').balance).to eq 1725.60

        expect(Account.where(account_number: '3212343433335755').count).to eq 1
        expect(Account.find_by(account_number: '3212343433335755').balance).to eq 48679.50
      end
    end

    context 'with incorrect payer number' do
      let(:row3) { '3212343433335751, 1111234522226789, 320.50' }

      it 'import failed with error' do
        expect { import }.to raise_error(DailyTransactionCsvImportService::TransactionCreateError, /Line 3 Payer/)
      end
    end

    context 'with incorrect payer number data type' do
      let(:row3) { 'asdf, 1111234522226789, 320.50' }

      it 'import failed with error' do
        expect { import }.to raise_error(DailyTransactionCsvImportService::TransactionCreateError, /Line 3 Payer/)
      end
    end

    context 'with incorrect payee number' do
      let(:row4) { '1111234522221234, 1212343433335165, 25.60' }

      it 'import failed with error' do
        expect { import }.to raise_error(DailyTransactionCsvImportService::TransactionCreateError, /Line 4 Payee/)
      end
    end

    context 'with incorrect payee number data type' do
      let(:row4) { '1111234522221234, asdf, 25.60' }

      it 'import failed with error' do
        expect { import }.to raise_error(DailyTransactionCsvImportService::TransactionCreateError, /Line 4 Payee/)
      end
    end

    context 'with incorrect amount data type' do
      let(:row4) { '1111234522221234, 1212343433335665, asdf' }

      it 'import failed with error' do
        expect { import }.to raise_error(DailyTransactionCsvImportService::TransactionCreateError, /amount/)
      end
    end

    context 'with amount more than account balance' do
      let(:row1) { '1111234522226789, 1212343433335665, 50000.00' }

      it 'import failed with error' do
        expect { import }.to raise_error(DailyTransactionCsvImportService::TransactionCreateError, /insufficient/)
      end
    end
  end
end
