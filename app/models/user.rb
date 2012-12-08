class User < ActiveRecord::Base
  attr_accessible :aruji, :display_name, :login_name, :mail_address, :password_digest
end
