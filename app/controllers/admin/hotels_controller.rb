class Admin::HotelsController < Admin::ApplicationController
  before_action :require_admin_login
  before_action :set_hotel, only: [:show, :edit, :update]

  def index
    @hotels = Hotel.order(:id)
  end

  def show
    @hotel = Hotel.find(params[:id])
    @rooms = @hotel.rooms.order(:id)
  
    @reservations = @hotel.reservations
                          .includes(:account, :room)
                          .order(check_in_on: :asc, created_at: :desc)
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      redirect_to admin_hotels_path, notice: "ホテルを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @hotel.update(hotel_params)
      redirect_to admin_hotel_path(@hotel), notice: "ホテル情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    hotel = Hotel.find(params[:id])
    hotel.destroy
    redirect_to admin_hotels_path, notice: "ホテルを削除しました"
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def hotel_params
    params.require(:hotel).permit(
      :name, :address, :area, :phone_number,
      :parking_capacity,
      :wifi, :large_bath, :openair_bath, :sauna, :bedrock_bath,
      :barrier_free, :smoking_area,
      :information, :hotel_photo
    )
  end
end
