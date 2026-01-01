class HotelsController < ApplicationController
  def index
    @area = params[:area].to_s.strip
    @check_in_on = params[:check_in_on]
    @stay_count = params[:stay_count]
    @guest_count = params[:guest_count]

    scope = Hotel.all
    scope = scope.where("area LIKE ?", "%#{@area}%") if @area.present?

    @hotels = scope.order(:id)
  end

  def show
    @hotel = Hotel.find(params[:id])
    @rooms = @hotel.rooms.order(:id)
  end
end