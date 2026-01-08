class AddUniqueIndexToAccountsEmail < ActiveRecord::Migration[7.0]
  def change
    remove_index :accounts, :email if index_exists?(:accounts, :email)
    add_index :accounts, :email, unique: true
  end
end