class Admin::ApplicationController < ActionController::Base
  helper_method :current_admin, :admin_logged_in?

  private

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def admin_logged_in?
    current_admin.present?
  end

  def require_admin_login
    return if admin_logged_in?
    redirect_to new_admin_session_path, alert: "管理者ログインしてください"
  end
end
