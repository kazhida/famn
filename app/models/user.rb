
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :login_name, :display_name, :password, :mail_address, :aruji

  validates_presence_of :login_name
  validates_presence_of :display_name
  validates_presence_of :password_digest
  validates_presence_of :mail_address
  validates_presence_of :aruji

  validates_uniqueness_of :login_name

  validates_length_of :password, {minimum: 6, allow_blank: true}

  before_validation do
    self.password_digest = BCrypt::Password.create(self.password)
  end
end
