class Neighborhood < ActiveRecord::Base
  belongs_to :family

  attr_accessible :family_id
  attr_accessible :neighbor_id
  attr_accessible :accepted
  attr_accessible :rejected

  validates_presence_of :family_id
  validates_presence_of :neighbor_id
  validates_inclusion_of :accepted, :in => [false, true]
  validates_inclusion_of :rejected, :in => [false, true]

  validates :neighbor_id, :uniqueness => {:scope => :family_id}

  validate do
    if accepted && rejected
      errors.add(:accepted, 'cannot accept and reject.')
    end
  end

  def accept
    self.accepted = true
    self.rejected = false
    save
  end

  def reject
    self.accepted = false
    self.rejected = true
    save
  end

  def suspend
    self.accepted = false
    self.rejected = false
    save
  end

  def suspended?
    not (rejected? || accepted?)
  end

  def self.add_neighborhood(family, neighborhood)
    family = family.id              if family.kind_of?(Family)
    neighborhood = neighborhood.id  if neighborhood.kind_of?(Family)

    if family && neighborhood
      n = neighborhood_of(family, neighborhood)
      if n.nil?
        n = Neighborhood.new
        n.family_id = family
        n.neighbor_id = neighborhood
        n.accepted = false
        n.rejected = false
        n.save
      end
    end
  end

  def self.neighborhood_of(family_id, neighbor_id = nil)
    if neighbor_id.nil?
      where :family_id => family_id
    else
      Neighborhood.find_by_family_id_and_neighbor_id(family_id, neighbor_id)
    end
  end
end
