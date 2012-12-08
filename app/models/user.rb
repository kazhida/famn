class User < ActiveRecord::Base
  attr_accessible :login_name, :display_name, :password_digest, :mail_address, :aruji

  validates :login_name, :presence => true
  validates :display_name, :presence => true
  validates :password_digest, :presence => true
  validates :mail_address, :presence => true
  validates :aruji, :presence => true
end
