class Entry < ActiveRecord::Base
  belongs_to :family
  belongs_to :user

  attr_accessible :message, :user, :family, :posted_on

  validates_presence_of :message
  validates_presence_of :user
  validates_presence_of :family
  validates_presence_of :posted_on

  def self.by_user(user)
    user.family.entries.sort do |e1, e2|
      # 降順でソート
      e2.posted_on <=> e1.posted_on
    end
  end

  def posted_on_as_string
    if posted_on.today?
      posted_on.strftime('%H:%M:%S')
    else
      posted_on.strftime('%y/%m/%d')
    end
  end
end

