class AddUniqueIndexToRoomsHotelIdRoomType < ActiveRecord::Migration[7.0]
  def change
    add_index :rooms, [:hotel_id, :room_type], unique: true
  end
end
