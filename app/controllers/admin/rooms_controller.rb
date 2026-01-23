class Admin::RoomsController < Admin::ApplicationController
  before_action :require_admin_login
  before_action :set_hotel
  before_action :set_room, only: [:edit, :update, :destroy]

  def new
    @room = @hotel.rooms.new(room_type: nil)
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
    @hotel = Hotel.find(params[:hotel_id])
    @room  = @hotel.rooms.find(params[:id])
  
    old_stock = @room.room_stock
  
    if @room.update(room_params)
      new_stock = @room.room_stock
      diff = new_stock - old_stock
  
      if diff != 0
        RoomInventory.transaction do
          @room.room_inventories
               .where("date >= ?", Date.current)
               .find_each do |inv|
  
            new_available = inv.available_count + diff
  
            new_available = 0 if new_available < 0
  
            new_available = new_stock if new_available > new_stock
  
            inv.update!(available_count: new_available)
          end
        end
      end
  
      redirect_to admin_hotel_path(@hotel), notice: "部屋情報を更新しました"
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
