class WorkRoleAuthor < ActiveRecord::Base

  self.primary_key = :work_id

  belongs_to :work
  belongs_to :role
  belongs_to :author

  validates_presence_of :work_id, :role_id, :author_id
  validates_uniqueness_of :work_id, scope: [ :role_id, :author_id ]
  validates_uniqueness_of :author_id, scope: [ :work_id, :role_id ]
  validates_uniqueness_of :role_id, scope: [ :work_id, :author_id ]

  def exists?
    res = !new_record?
    res = !self.class.where('work_id = ? and author_id = ? and role_id = ?', self.work_id, self.author_id, self.role_id).empty? unless res
    res
  end

end
