class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :message, :null => false
      t.integer :user_id, :null => false
      t.integer :family_id, :null => false

      t.timestamps
    end
  end
end
