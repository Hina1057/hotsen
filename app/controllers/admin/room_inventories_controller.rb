class Admin::RoomInventoriesController < Admin::ApplicationController
    before_action :set_hotel
    before_action :set_room
  
    def index
      @from = Date.current
      @to = @from + 30.days
  
      ensure_inventories!(@from, @to)
  
      @inventories = @room.room_inventories
                         .where(date: @from..@to)
                         .order(:date)
    end

    def edit
        @inventory = @room.room_inventories.find(params[:id])
      end
      
      def update
        @inventory = @room.room_inventories.find(params[:id])
      
        if @inventory.update(inventory_params)
          redirect_to admin_hotel_room_room_inventories_path(@hotel, @room),
                      notice: "日別在庫を更新しました"
        else
          render :edit, status: :unprocessable_entity
        end
      end
      
    private
      
    def inventory_params
        params.require(:room_inventory).permit(:available_count)
    end
  
    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
  
    def set_room
      @room = @hotel.rooms.find(params[:room_id])
    end
  
    # ★ これが ensure_inventories
    def ensure_inventories!(from, to)
      (from..to).each do |d|
        @room.room_inventories.find_or_create_by!(date: d) do |inv|
          inv.available_count = @room.room_stock
        end
      end
    end
  end