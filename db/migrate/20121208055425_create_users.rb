class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login_name
      t.string :display_name
      t.string :password_digest
      t.string :mail_address
      t.boolean :aruji

      t.timestamps
    end
  end
end
