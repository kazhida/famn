class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.integer :entry_id
      t.string :name

      t.timestamps
    end
  end
end
