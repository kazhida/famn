class AddVerificationTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :verification_token, :string
  end
end
