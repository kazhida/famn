class Entry < ActiveRecord::Base
  attr_accessible :family_id, :message, :user_id
end
