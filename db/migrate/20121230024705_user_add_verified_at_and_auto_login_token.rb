class UserAddVerifiedAtAndAutoLoginToken < ActiveRecord::Migration
  def change
    add_column :users, :verified_at, :datetime
    add_column :users, :auto_login_token, :string
  end
end
