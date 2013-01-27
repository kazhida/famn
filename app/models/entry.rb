# -*- encoding: utf-8 -*-

class Entry < ActiveRecord::Base
  belongs_to :family
  belongs_to :user

  #pagenates_per 20

  attr_accessible :message
  attr_accessible :user
  attr_accessible :family
  attr_accessible :posted_on

  validates_presence_of :message
  validates_presence_of :user
  validates_presence_of :family
  validates_presence_of :posted_on

  validate do
    if (not message.nil?) && (message.length > 250)
      errors.add(:login_name, 'message length <= 250.')
    end
  end

  before_validation do
    self.family_id = user ? user.family.id : nil
  end

  before_save do
    self.message = CGI.escape_html(self.message)
  end

  def self.by_user(user)
    mention = "%@#{user.family.login_name} %"
    where('family_id=? OR message LIKE ?', user.family_id, mention).order('posted_on DESC')
    #user.family.entries.order('posted_on DESC')
  end

  def self.post(user, message)
    entry = Entry.new
    entry.message   = message
    entry.user      = user
    entry.family    = user.family
    entry.posted_on = DateTime.current
    entry.save
  end

  def posted_on_as_string
    if posted_on.today?
      posted_on.strftime('%H:%M:%S')
    else
      posted_on.strftime('%y/%m/%d')
    end
  end
end

