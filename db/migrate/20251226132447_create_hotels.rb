class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :area, null: false
      t.string :phone_number, null: false

      t.boolean :wifi, default: false, null: false
      t.boolean :large_bath, default: false, null: false
      t.boolean :openair_bath, default: false, null: false
      t.boolean :sauna, default: false, null: false
      t.boolean :bedrock_bath, default: false, null: false
      t.boolean :barrier_free, default: false, null: false
      t.boolean :smoking_area, default: false, null: false

      t.text :information
      t.string :hotel_photo

      t.timestamps
    end
  end
end
