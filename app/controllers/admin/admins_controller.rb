class Admin::AdminsController < Admin::ApplicationController
  before_action :require_admin_login
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    @admins = Admin.order(:id)
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      redirect_to admin_accounts_path, notice: "管理者を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @admin.update(admin_update_params)
      redirect_to admin_accounts_path, notice: "管理者を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 管理者が1人しかいない場合は削除不可
    if Admin.count <= 1
      redirect_to admin_accounts_path, alert: "管理者が1人しかいないため削除できません"
      return
    end
  
    admin = Admin.find(params[:id])
  
    # 自分自身を削除する場合
    if admin.id == current_admin.id
      admin.destroy
  
      # セッションをクリア（ここ重要）
      reset_session
  
      redirect_to new_admin_session_path, notice: "アカウントを削除しました"
      return
    end
  
    # 他の管理者を削除する場合
    admin.destroy
    redirect_to admin_accounts_path, notice: "管理者を削除しました"
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:name, :password, :password_confirmation)
  end

  # 編集でパスワード未入力なら変更しない用
  def admin_update_params
    p = params.require(:admin).permit(:name, :password, :password_confirmation)
    if p[:password].blank? && p[:password_confirmation].blank?
      p.except(:password, :password_confirmation)
    else
      p
    end
  end
end
