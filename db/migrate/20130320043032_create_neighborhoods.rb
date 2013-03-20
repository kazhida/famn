class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.integer :family_id
      t.integer :neighbor_id

      t.timestamps
    end
  end
end
