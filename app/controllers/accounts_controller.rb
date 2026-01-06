class AccountsController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :forbid_other_account, only: [:show, :edit, :update]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      session[:account_id] = @account.id
      redirect_to account_path(@account), notice: "登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @account = Account.find(params[:id])
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      redirect_to account_path(@account), notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def reservations
    # 他人の予約一覧を見せない
    if params[:id].to_i != current_account.id
      redirect_to account_path(current_account), alert: "権限がありません"
      return
    end

    @reservations = current_account.reservations
                                  .includes(:hotel, :room)
                                  .order(check_in_on: :asc, created_at: :desc)
  end

  private

  def account_params
    params.require(:account).permit(
      :name, :email, :password, :password_confirmation,
      :address, :birthday, :sex, :phone_number
    )
  end
end
