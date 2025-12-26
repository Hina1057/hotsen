class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string  :name, null: false
      t.string  :email, null: false
      t.string  :password_digest, null: false
      t.string  :address, null: false
      t.date    :birthday, null: false
      t.integer :sex, null: false, default: 0
      t.string  :phone_number, null: false

      t.timestamps
    end

    add_index :accounts, :email, unique: true
  end
end
