class Author < ActiveRecord::Base

  belongs_to :owner, class_name: 'Account'


  has_many :works_roles_authors
  has_many :roles, through: :works_roles_authors, dependent: :destroy do
    #
    # <tt>for_work(work_id, force = false)</tt>
    #
    # this extension allows to select the roles for a specific work, something
    # that is impossible to do with the regular relationship accessors.
    #
    def for_work(work_id, force = false)
      where('works_roles_authors.work_id = ?', work_id)
    end
  end
  accepts_nested_attributes_for :roles

  validates_presence_of :first_name, :last_name, :owner_id

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  #
  # +display_birth_year+
  #
  def display_birth_year
    self.birth_year.to_s
  end

  #
  # +display_roles_for_work(work_id)+
  #
  # creates a comma separated list of roles
  #
  def display_roles_for_work(work_id)
    self.roles.for_work(work_id).map { |r| r.description }.uniq.sort.join(', ')
  end

end
