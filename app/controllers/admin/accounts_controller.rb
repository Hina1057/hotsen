class Admin::AccountsController < ApplicationController
  before_action :require_admin_login
  
  def index
    @accounts = Account.order(:id)
  end

  def show
    @account = Account.find(params[:id])
  end
end
