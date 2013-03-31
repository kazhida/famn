class UserAddPostedOn < ActiveRecord::Migration
  def change
    add_column :users, :posted_on, :datetime, :null => false
  end
end
