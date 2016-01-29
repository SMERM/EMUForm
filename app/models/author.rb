class Author < ActiveRecord::Base

  has_many :author_work_roles
  has_many :works, -> { includes :roles }, through: :author_work_roles, source: :work
  has_many :roles, -> { includes :works }, through: :author_work_roles, source: :role

  validates_presence_of :first_name, :last_name
  before_destroy :handle_destruction_of_associated_works

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  def add_work_with_role(w, r)
    AuthorWorkRole.create(:author_id => self.to_param, :work_id => w.to_param, :role_id => r.to_param)    
  end

  def remove_work_with_role(w, r)
    awr = AuthorWorkRole.where('author_id = ? and work_id = ? and role_id = ?', self.id, w.id, r.id)
    awr.destroy if awr && awr.valid?
  end

  #
  # +works_with_roles+
  #
  # +works_with_roles+:
  # * find all the relations between an author and a work (uniqe name)
  # * returns an array of hashes with the work and a list of roles for it
  #   like:
  #
  #   => [{ :work => <Work:class>, :roles => [ <Role:class>, <Role:class>, ...  ] }, { :work => .... } ]
  #
  def works_with_roles(force = false)
    res = []
    wks = self.works(force).uniq
    wks.each do
      |wk|
      h = { :work => wk }
      h.update(:roles => AuthorWorkRole.where('author_id = ? and work_id = ?', self.id, wk.id).map { |awr| awr.role })
      res << h
    end
    res
  end

private

  #
  # + handle_destruction_of_associated_works+
  #
  # clears all HABTM relationships with associated works.
  # Clears also work records if they do not belong to any other author
  #
  def handle_destruction_of_associated_works
    ws = self.works.map { |w| w }
    self.works.clear
    ws.each { |w| w.destroy if w.authors(true).empty? }
  end

end
