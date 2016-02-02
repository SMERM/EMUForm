class Author < ActiveRecord::Base

  has_many :author_work_roles
  has_many :works, -> { includes :roles }, through: :author_work_roles, source: :work
  has_many :roles, -> { includes :works }, through: :author_work_roles, source: :role

  validates_presence_of :first_name, :last_name
  before_destroy :handle_destruction_of_associated_works

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  class << self

    #
    # <tt>add_work_with_role(a_id, w_id, r_id)</tt>
    #
    # adds a three-way link between an author, a work and a role (class
    # method)
    #
    def add_work_with_role(a_id, w_id, r_id)
      AuthorWorkRole.create(:author_id => a_id, :work_id => w_id, :role_id => r_id)
    end
  
    #
    # <tt>detach_role_from_a_work(a_id, w_id, r_id)</tt>
    #
    # removes a three-way link between an author, a work and a role (class
    # method). This does not destroy any of the linked records (author, work,
    # or role).
    #
    def detach_role_from_a_work(a_id, w_id, r_id)
      awr = AuthorWorkRole.where("author_id = #{a_id} and work_id = #{w_id} and role_id = #{r_id}").first
      awr.valid? && awr.destroy
      awr
    end

    #
    # <tt>detach_a_work(a_id, w_id)</tt>
    #
    # removes all three-way links between an author and a work (class method).
    # This does not destroy any of the linked records (author, work,
    # or role), but just any connection between an author and a work.
    #
    def detach_a_work(a_id, w_id)
      AuthorWorkRole.destroy_all("author_id = #{a_id} and work_id = #{w_id}") if a_id && w_id
    end

  end

  #
  # <tt>add_work_with_role(work, role)</tt>
  #
  # adds a three-way link between an author, a work and a role (instance
  # method)
  #
  def add_work_with_role(w, r)
    self.class.add_work_with_role(self.to_param, w.to_param, r.to_param)
  end

  #
  # <tt>detach_role_from_a_work(work, role)</tt>
  #
  # removes a three-way link between an author, a work and a role (instance
  # method). This does not destroy any of the linked records (author, work,
  # or role).
  #
  def detach_role_from_a_work(w, r)
    self.class.detach_role_from_a_work(self.to_param, w.to_param, r.to_param)
  end

  #
  # <tt>detach_a_work(work)</tt>
  #
  # removes all three-way links between an author and a work (instance method).
  # This does not destroy any of the linked records (author, work,
  # or role), but just any connection between an author and a work.
  #
  def detach_a_work(work)
    self.class.detach_a_work(self.to_param, work.to_param)
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

  #
  # +display_birth_year+
  #
  def display_birth_year
    self.birth_year.year
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
