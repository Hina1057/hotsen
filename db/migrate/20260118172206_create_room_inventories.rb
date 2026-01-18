class CreateRoomInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :room_inventories do |t|
      t.references :room, null: false, foreign_key: true
      t.date :date
      t.integer :available_count

      t.timestamps
    end
    add_index :room_inventories, [:room_id, :date], unique: true
  end
end
