class AddNoticeToUser < ActiveRecord::Migration
  def change
    add_column :users, :notice, :boolean, :null => false, :default => true
    add_column :users, :notice_only_replied, :boolean, :null => false, :default => false
  end
end
