class Destination < ActiveRecord::Base
  belongs_to :entry
  attr_accessible :entry_id, :name
end
