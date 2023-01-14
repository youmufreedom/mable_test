# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'daily transaction views', type: :view do
  feature 'index view' do
    feature 'page content' do
      scenario 'has title' do
        visit accounts_daily_transaction_imports_path

        expect(page).to have_text 'Daily Transaction Imports'
        expect(page).to have_selector(:link_or_button, 'Import')
        expect(page).to have_selector(:link_or_button, 'Back')
      end
    end
  end
end
