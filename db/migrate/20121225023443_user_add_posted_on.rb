class UserAddPostedOn < ActiveRecord::Migration
  def change
    add_column :users, :posted_on, :date
  end
end
