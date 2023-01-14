# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DailyTransactionImports', type: :request do
  describe 'GET index' do
    it 'loads resources, returns http success and render template' do
      get '/accounts/daily_transaction_imports'

      expect(response).to have_http_status(:success)
      expect(response).to render_template :index
    end
  end

  describe 'POST create' do
    let!(:account1) { Account.create(account_number: '1111234522226789', balance: 5000.00) }
    let!(:account2) { Account.create(account_number: '1111234522221234', balance: 10_000.00) }
    let!(:account3) { Account.create(account_number: '2222123433331212', balance: 550.00) }
    let!(:account4) { Account.create(account_number: '1212343433335665', balance: 1200.00) }
    let!(:account5) { Account.create(account_number: '3212343433335755', balance: 50_000.00) }

    let(:file) { fixture_file_upload(Rails.root.join('public', 'sample_data', 'mable_trans.csv'), 'text/csv') }
    subject { post '/accounts/daily_transaction_imports', params: { file: file } }

    it 'test' do
      expect { subject }.to change { Transaction.count }.from(0).to(4)
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq 'Records Import successfully'
    end
  end
end
