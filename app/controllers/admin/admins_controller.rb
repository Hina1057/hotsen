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
      redirect_to admin_admins_path, notice: "管理者を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @admin.update(admin_update_params)
      redirect_to admin_admins_path, notice: "管理者を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if Admin.count <= 1
      redirect_to admin_admins_path, alert: "管理者が1人になるため削除できません"
      return
    end

    if @admin.id == current_admin.id
      redirect_to admin_admins_path, alert: "自分自身は削除できません"
      return
    end

    @admin.destroy
    redirect_to admin_admins_path, notice: "管理者を削除しました"
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
