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
    entries = Entry.arel_table
    from_family = entries[:family_id].eq(user.family_id)

    dest = Destination.arel_table
    from_others = entries[:id].in(dest.project(dest[:entry_id]).where(dest[:name].eq(user.family.login_name)))

    neighbor = Neighborhood.arel_table
    accept_families = neighbor.project(neighbor[:neighbor_id]).where(neighbor[:family_id].eq(user.family_id))
    if user.aruji
      accept_families = accept_families.where(neighbor[:rejected].eq(false))
    else
      accept_families = accept_families.where(neighbor[:accepted].eq(true))
    end
    from_others = from_others.and (entries[:family_id].in(accept_families.ast))

    #cond1 = entries[:id].in(dest.project(dest[:entry_id]).where(dest[:name].eq(user.family.login_name)))
    #cond1 = cond1.and entries[:family_id].in(neighbor)
    #cond = from_family.or cond1
    where(from_family.or from_others).order('posted_on DESC')
  end

  def set_message(msg)
    self.message = msg
    @destinations = Array.new

    unless msg.nil?
      msg.gsub(/@(\w+)\s|$/) do
        @destinations.push "#{$1}"  unless $1.nil? or $1.empty?
        "#{$1}"
      end
    end
  end

  def self.post!(user, message, face, &proc)
    entry = Entry.new
    entry.user      = user
    entry.family    = user.family
    entry.posted_on = DateTime.current
    entry.set_message Jpmobile::Emoticon.external_to_unicodecr_unicode60(message)
    entry.face      = face
    print entry.message

    transaction do
      entry.save!

      entry.destinations.each do |dest|
        Destination.create!(entry_id: entry.id, name: dest)
        Neighborhood.add_neighborhood(Family.find_by_login_name(dest), entry.family)
      end
      unless proc.nil?
        proc.call entry
      end
    end
  end

  def icon
    "face_#{user.face}_#{face}.png"
  end

  def posted_on_as_string
    if posted_on.today?
      posted_on.strftime('%H:%M:%S')
    else
      posted_on.strftime('%m/%d %H:%M')
    end
  end
end

