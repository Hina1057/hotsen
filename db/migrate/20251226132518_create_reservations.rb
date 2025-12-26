class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :account, null: false, foreign_key: true
      t.references :hotel,   null: false, foreign_key: true
      t.references :room,    null: false, foreign_key: true

      t.date    :check_in_on, null: false
      t.integer :stay_count, null: false, default: 1
      t.integer :guest_count, null: false, default: 1

      t.integer :pay_method, null: false, default: 0
      t.boolean :breakfast, null: false, default: false
      t.boolean :dinner,    null: false, default: false

      t.integer :total_price, null: false, default: 0

      t.timestamps
    end
  end
end
