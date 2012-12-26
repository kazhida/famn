
require 'bcrypt'

class User < ActiveRecord::Base
  belongs_to :family

  attr_accessor :password
  attr_accessible :login_name, :display_name, :family, :password, :mail_address, :aruji

  validates_presence_of :login_name

  validate do
    if User.find_by_login_name_and_family_id(login_name, family_id).nil?
      if Family.find_by_login_name(login_name).nil?
        true
      else
        errors.add(:login_name, '%s is already used at families.' % login_name)
        false
      end
    else
      errors.add(:login_name, '%s is already used at users same family.' % login_name)
      false
    end
  end

  validates_presence_of :display_name
  validates_presence_of :family
  validates_presence_of :password_digest
  validates_presence_of :mail_address
  validates_length_of :password, :minimum => 6

  has_many :entries, :dependent => :destroy

  before_validation do
    self.password_digest = BCrypt::Password.create(self.password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def self.find_by_names(family_name, user_name)
    family = Family.find_by_login_name(family_name)
    find_by_login_name_and_family_id(user_name, family.nil? ? nil : family.id)
  end
end
