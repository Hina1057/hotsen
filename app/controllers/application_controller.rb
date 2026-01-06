class ApplicationController < ActionController::Base
    helper_method :current_account, :logged_in?
    helper_method :current_admin, :admin_logged_in?
    private
  
    def current_account
      return @current_account if defined?(@current_account)
      @current_account = Account.find_by(id: session[:account_id])
    end
  
    def logged_in?
      current_account.present?
    end
  
    def require_login
      return if logged_in?
      redirect_to new_session_path, alert: "ログインしてください"
    end
  
    def forbid_other_account
      return unless logged_in?
      if current_account.id != params[:id].to_i
        redirect_to account_path(current_account), alert: "権限がありません"
      end
    end

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
  