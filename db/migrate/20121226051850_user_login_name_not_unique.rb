class UserLoginNameNotUnique < ActiveRecord::Migration
  def change
    remove_index :users, :login_name
    add_index :users, :login_name
  end
end
