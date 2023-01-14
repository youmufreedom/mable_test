# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts::AccountImports', type: :request do
  describe 'GET index' do
    it 'loads resources, returns http success and render template' do
      get '/accounts/account_imports'

      expect(response).to have_http_status(:success)
      expect(response).to render_template :index
    end
  end

  describe 'POST create' do
    let(:file) { fixture_file_upload(Rails.root.join('public', 'sample_data', 'mable_acc_balance.csv'), 'text/csv') }
    subject { post '/accounts/account_imports', params: { file: file } }

    it 'test' do
      expect { subject }.to change { Account.count }.from(0).to(5)
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq 'Records Import successfully'
    end
  end
end
