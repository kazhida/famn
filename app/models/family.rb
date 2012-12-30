class Family < ActiveRecord::Base

  attr_accessible :login_name
  attr_accessible :display_name

  validates_presence_of :login_name
  validates_uniqueness_of :login_name

  validate do
    if not /^[0-9a-zA-Z_]+$/ =~ login_name then
      errors.add(:login_name, '%s must be number, alphabetic character or "_".' % login_name)
    elsif not User.find_by_login_name(login_name).nil?
      errors.add(:login_name, '%s is already used at users.' % login_name)
    end
  end

  validates_presence_of :display_name

  has_many :users,   :dependent => :destroy
  has_many :entries, :dependent => :destroy
end
