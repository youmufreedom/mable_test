# frozen_string_literal: true

class Accounts::DailyTransactionImportsController < ApplicationController
  def create
    return redirect_to accounts_daily_transaction_imports_path, notice: 'No file added' if params[:file].nil?
    return redirect_to accounts_daily_transaction_imports_path, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    begin
      DailyTransactionCsvImportService.call(params[:file])
      redirect_to accounts_daily_transaction_imports_path, notice: 'Records Import successfully'
    rescue DailyTransactionCsvImportService::TransactionCreateError => e
      redirect_to accounts_daily_transaction_imports_path, notice: e.message
    end
  end
end
