class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :require_admin_login, only: [:new, :create]
  
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
    reset_session
    redirect_to new_admin_session_path, notice: "ログアウトしました"
  end
end
