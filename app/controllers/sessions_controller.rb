class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.find_by(name: params[:name])

    if account&.authenticate(params[:password])
      session[:account_id] = account.id
      redirect_to root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "名前かパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "ログアウトしました"
  end
end
