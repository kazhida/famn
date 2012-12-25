class UserAndEntryMovePostedOn < ActiveRecord::Migration
  def change
    add_column :entries, :posted_on, :date
    remove_column :users, :posted_on
  end
end
