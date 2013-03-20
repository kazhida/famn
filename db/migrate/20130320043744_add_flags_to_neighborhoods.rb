class AddFlagsToNeighborhoods < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :rejected, :boolean, :null => false, :default => false
    add_column :neighborhoods, :accepted, :boolean, :null => false, :default => false
  end
end
