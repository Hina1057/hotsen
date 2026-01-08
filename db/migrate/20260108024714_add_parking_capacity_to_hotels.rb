class AddParkingCapacityToHotels < ActiveRecord::Migration[7.0]
  def change
    add_column :hotels, :parking_capacity, :integer
  end
end
