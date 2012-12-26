class Family < ActiveRecord::Base
  attr_accessible :login_name, :display_name

  validates_presence_of :login_name
  validates_uniqueness_of :login_name

  validate do
    unless User.find_by_login_name(login_name).nil?
      errors.add(:login_name, '%s is already used at users.' % login_name)
    end
  end

  validates_presence_of :display_name

  has_many :users,   :dependent => :destroy
  has_many :entries, :dependent => :destroy
end
