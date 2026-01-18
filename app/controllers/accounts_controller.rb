class AccountsController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :forbid_other_account, only: [:show, :edit, :update]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    Rails.logger.debug "password length = #{params.dig(:account, :password).to_s.length}"
    if @account.save
      # 自動ログインしない
      redirect_to new_session_path, notice: "登録が完了しました。ログインしてください"
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

  def destroy
    @account = current_account
  
    ActiveRecord::Base.transaction do
      @account.reservations.destroy_all
      @account.destroy!
    end
  
    reset_session
    redirect_to root_path, notice: "退会処理が完了しました。ご利用ありがとうございました。"
  rescue
    redirect_to account_path(@account), alert: "退会処理に失敗しました"
  end

  def reservations
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
