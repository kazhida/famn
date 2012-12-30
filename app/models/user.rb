
require 'bcrypt'

class User < ActiveRecord::Base
  belongs_to :family

  attr_reader     :password
  attr_accessor   :current_password
  attr_reader     :new_password
  attr_writer     :setting_password
  attr_writer     :changing_password

  attr_accessible :login_name
  attr_accessible :display_name
  attr_accessible :family
  attr_accessible :password
  attr_accessible :password_confirmation
  attr_accessible :setting_password
  attr_accessible :mail_address
  attr_accessible :aruji
  attr_accessible :current_password
  attr_accessible :new_password
  attr_accessible :new_password_confirmation

  def setting_password?;  @setting_password;    end
  def changing_password?; @changing_password;   end
  def verified?;          verified_at.present?; end

  def password=(pw)
    @password = pw
    @setting_password = true
  end

  def new_password=(pw)
    @new_password = pw
    @changing_password = true
  end


  validates_presence_of :login_name

  validate do
    if not /^[0-9a-zA-Z_]+$/ =~ login_name
      # 英数字+_
      errors.add(:login_name, '%s must be number, alphabetic character or "_".' % login_name)
    elsif not User.find_by_login_name_and_family_id(login_name, family_id).nil?
      # 同じ家族でかぶっている
      errors.add(:login_name, '%s is already used at families.' % login_name)
    elsif not Family.find_by_login_name(login_name).nil?
      # どこかの家族名とかぶっている
      errors.add(:login_name, '%s is already used at users same family.' % login_name)
    end
  end

  validate do
    if changing_password? && !authenticate(current_password)
      # パスワード変更時に現在のパスワードが違っている
      errors.add(:current_password, :invalid)
    end
  end

  validates_presence_of     :display_name
  validates_presence_of     :family
  validates_presence_of     :password_digest
  validates_presence_of     :mail_address
  validates_length_of       :password, :minimum => 6, :allow_blank =>true
  validates_confirmation_of :password
  validates_length_of       :new_password, :minimum => 6, :allow_blank =>true
  validates_confirmation_of :new_password

  has_many :entries, :dependent => :destroy

  before_validation do
    if changing_password?
      self.password_digest = BCrypt::Password.create(new_password)
    elsif setting_password?
      self.password_digest = BCrypt::Password.create(password)
    end
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def self.find_by_names(family_name, user_name)
    family = Family.find_by_login_name(family_name)
    find_by_login_name_and_family_id(user_name, family.nil? ? nil : family.id)
  end
end
