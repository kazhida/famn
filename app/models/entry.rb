# -*- encoding: utf-8 -*-

class Entry < ActiveRecord::Base
  belongs_to :family
  belongs_to :user
  has_many   :destination, :dependent => :destroy

  attr_accessible :message
  attr_accessible :user
  attr_accessible :family
  attr_accessible :posted_on
  attr_accessible :face
  attr_reader     :destinations

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

  def self.by_user(user)
    # todo:Arelムツカシネ
    #dests = Arel::Table.new :destinations
    #tbl = arel_table.join(dests).on(arel_table[:id].eq(dests[:entry_id]))
    #cond = tbl[:family_id].eq(user.family_id)
    #cond = cond.or(tbl[:name].eq(user.family.login_name))
    #Entry.includes(:destination).where(cond).order('posted_on DESC')

    mention = "%@#{user.family.login_name} %"
    where('family_id=? OR message LIKE ?', user.family_id, mention).order('posted_on DESC')
  end

  def receivers

  end

  def set_destination(message)
    @destinations = Array.new

    message.gsub(/(@\w+)\s|$/) do
      @destinations.push "#{$1}"  unless $1.nil? or $1.empty?
      ''
    end
  end

  def self.post(user, message, face, &proc)
    entry = Entry.new
    entry.message   = message
    entry.user      = user
    entry.family    = user.family
    entry.posted_on = DateTime.current
    entry.face      = face
    entry.set_destination message

    transaction do
      entry.save!
      entry.destinations.each do |destination|
        Destination.create!(entry_id: entry.id, name: destination)
      end
      proc.call entry
    end
    true
    rescue => e
    false
  end

  def icon
    "face_#{user.face}_#{face}.png"
  end

  def posted_on_as_string
    if posted_on.today?
      posted_on.strftime('%H:%M:%S')
    else
      posted_on.strftime('%y/%m/%d')
    end
  end
end

