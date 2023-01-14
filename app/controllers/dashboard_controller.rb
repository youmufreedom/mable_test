# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :accounts, only: %i[index]

  def index; end

  private

  def accounts
    @accounts = Account.all
  end
end
