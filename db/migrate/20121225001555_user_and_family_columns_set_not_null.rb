class UserAndFamilyColumnsSetNotNull < ActiveRecord::Migration
  def change
    change_column :users, :login_name, :string, :null =>  false, :limit => 64
    change_column :users, :display_name, :string, :null =>  false, :limit => 250
    change_column :users, :mail_address, :string, :null => false, :limit => 250
    change_column :users, :aruji, :boolean, :null =>  false, :default => false
    add_index :users, :login_name, :unique => true

    change_column :families, :name, :string, :null =>  false, :limit => 64
    add_index :families, :name, :unique => true
  end
end
