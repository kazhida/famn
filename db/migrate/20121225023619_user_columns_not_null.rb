class UserColumnsNotNull < ActiveRecord::Migration
  def change
    change_column :users, :family_id, :integer, :null => false
    #change_column :users, :posted_on, :date, :null => false
  end
end
