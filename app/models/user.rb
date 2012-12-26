
require 'bcrypt'

class User < ActiveRecord::Base
  belongs_to :family

  attr_accessor :password
  attr_accessible :login_name, :display_name, :family, :password, :mail_address, :aruji

  validates_presence_of :login_name
  validates_uniqueness_of :login_name

  validate do
    unless Family.find_by_login_name(login_name).nil?
      errors.add(:login_name, '%s is already used at families.' % login_name)
    end
  end

  validates_presence_of :display_name
  validates_presence_of :family
  validates_presence_of :password_digest
  validates_presence_of :mail_address
  validates_length_of :password, :minimum => 6

  before_validation do
    self.password_digest = BCrypt::Password.create(self.password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end
end
