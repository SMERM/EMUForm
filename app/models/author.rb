class Author < ActiveRecord::Base

  belongs_to :owner, class_name: 'Account'

  has_many :author_work_roles
  has_many :works, -> { includes :roles }, through: :author_work_roles, source: :work
  has_many :roles, -> { includes :works }, through: :author_work_roles, source: :role

  validates_presence_of :first_name, :last_name
  accepts_nested_attributes_for :roles

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  #
  # +display_birth_year+
  #
  def display_birth_year
    self.birth_year
  end

  class << self

    #
    # <tt>build(parms)</tt>
    #
    # creates a new +Author+ record stripping out all attributes that create
    # connections with roles
    # it returns a tuple with:
    # * the new record
    # * the `roles_ids` array
    #
    def build(params = {})
      roles_ids = params.has_key?(:roles_attributes) ? params.delete(:roles_attributes) : []
      roles_ids = roles_ids.map { |rid| rid[:id] }
      params.delete(:work_id)
      obj = Author.new(params)
      [ obj, roles_ids ]
    end

  end

  #
  # <tt>save_with_roles(work, roles_ids)</tt>
  #
  # saves the +Author+ record along with the work and roles relationships
  #
  def save_with_work(work, roles_ids)
    res = save
    if res
      roles = Role.find(roles_ids)
      work.add_author_with_roles(self, roles)
    end
    res
  end

end
