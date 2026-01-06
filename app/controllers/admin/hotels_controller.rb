class Admin::HotelsController < Admin::ApplicationController
  before_action :require_admin_login

  def index
    @hotels = Hotel.order(:id)
  end

  def show
    @hotel = Hotel.find(params[:id])
    @rooms = @hotel.rooms.order(:id)
  end
end
