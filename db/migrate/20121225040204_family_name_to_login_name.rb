class FamilyNameToLoginName < ActiveRecord::Migration
  def change
    rename_column :families, :name, :login_name
  end
end
