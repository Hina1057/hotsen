class Admin::AccountsController < ApplicationController
  before_action :require_admin_login

  def index
    @accounts = Account.order(:id)
    @admins = Admin.order(:id)
  end

  def show
    @account = Account.find(params[:id])
    @admin = Admin.find(params[:id])
  end
end
