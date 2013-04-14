class ChangePostedOnToDatetime < ActiveRecord::Migration
  def change
    change_column :entries, :posted_on, :datetime, :null => false
  end
end
