class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.references :hotel, null: false, foreign_key: true

      t.integer :room_type, null: false, default: 0
      t.integer :max_person, null: false, default: 1
      t.integer :room_price, null: false
      t.integer :room_stock, null: false, default: 0
      t.string  :room_photo

      t.timestamps
    end
  end
end
