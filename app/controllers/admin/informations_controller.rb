class Admin::InformationsController < Admin::ApplicationController
  before_action :require_admin_login

  def index
    @informations = Information.order(created_at: :desc)
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.new(information_params)
    if @information.save
      redirect_to admin_informations_path, notice: "お知らせを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    information = Information.find(params[:id])
    information.destroy
    redirect_to admin_informations_path, notice: "お知らせを削除しました"
  end

  private

  def information_params
    params.permit(:title, :body)
  end
end
