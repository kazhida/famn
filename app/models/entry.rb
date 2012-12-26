class Entry < ActiveRecord::Base
  belongs_to :family
  belongs_to :user

  attr_accessible :message, :user, :family, :posted_on

  validates_presence_of :message
  validates_presence_of :user
  validates_presence_of :family
  validates_presence_of :posted_on

  def self.find_by_user(user)
    user.family.entries
  end
end
