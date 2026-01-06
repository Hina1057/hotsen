class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by(name: params[:name])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "名前かパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_id)
    redirect_to admin_root_path, notice: "ログアウトしました"
  end
end
