class Entry < ActiveRecord::Base
  attr_accessible :family_id, :message, :user_id

  validates_presence_of :message
  validates_presence_of :user_id
  validates_presence_of :family_id
end
