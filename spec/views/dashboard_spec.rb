# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'dashboard views', type: :view do
  feature 'index view' do
    feature 'page content' do
      scenario 'has title' do
        visit dashboard_index_path

        expect(page).to have_text 'Accounts List'
      end

      scenario 'has table' do
        visit dashboard_index_path

        expect(page).to have_css 'table'
      end

      scenario 'has products information' do
        visit dashboard_index_path

        within 'table' do
          expect(page).to have_text 'Account Number'
          expect(page).to have_text 'Balance'
        end
      end

      scenario 'has two links' do
        visit dashboard_index_path

        expect(page).to have_selector(:link_or_button, 'Account Import Page')
        expect(page).to have_selector(:link_or_button, 'Daily Transaction Import Page')
      end
    end
  end
end
