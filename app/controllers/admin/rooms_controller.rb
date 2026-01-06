class Admin::RoomsController < Admin::ApplicationController
  before_action :require_admin_login
  before_action :set_hotel
  before_action :set_room, only: [:edit, :update, :destroy]

  def new
    @room = @hotel.rooms.new
  end

  def create
    @room = @hotel.rooms.new(room_params)
    if @room.save
      redirect_to admin_hotel_path(@hotel), notice: "部屋を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to admin_hotel_path(@hotel), notice: "部屋を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    redirect_to admin_hotel_path(@hotel), notice: "部屋を削除しました"
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_room
    @room = @hotel.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:room_type, :max_person, :room_price, :room_stock)
  end
end
