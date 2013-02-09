class AddFaces < ActiveRecord::Migration
  def change
    add_column :users, :face, :string, :null => false, :default => 'gray'
    add_column :entries, :face, :integer, :null => false, :default => 0
  end
end
