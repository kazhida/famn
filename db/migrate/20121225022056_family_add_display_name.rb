class FamilyAddDisplayName < ActiveRecord::Migration
  def change
    add_column :families, :display_name, :string
  end
end
