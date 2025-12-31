class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.find_by(email: params[:name])

    if account&.authenticate(params[:password])
      session[:account_id] = account.id
      cookies.signed[:account_id] = {
        value: account.id,
        expires: 24.hours.from_now 
      }
    else
      flash.alert = "名前とパスワードが一致しません"
    end
    redirect_to :root
  end

  def destroy
    cookies.delete(:member_id)
    redirect_to :root
  end
end
