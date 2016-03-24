class WorkRoleAuthor < ActiveRecord::Base

  self.primary_key = :work_id

  belongs_to :work
  belongs_to :role
  belongs_to :author
  belongs_to :edition

  validates_presence_of :work_id, :role_id, :author_id, :edition_id
  validates_uniqueness_of :work_id, scope: [ :role_id, :author_id, :edition_id ]
  validates_uniqueness_of :author_id, scope: [ :work_id, :role_id, :edition_id ]
  validates_uniqueness_of :role_id, scope: [ :work_id, :author_id, :edition_id ]

  def exists?
    res = !new_record?
    res = !self.class.where('work_id = ? and author_id = ? and role_id = ?', self.work_id, self.author_id, self.role_id).empty? unless res
    res
  end

  before_validation :add_edition

private

  #
  # +add_edition+
  #
  # adds the current edition to the work as a reference unless it is already
  # set. Aptly called from a +before_validation+ callback.
  #
  def add_edition
    self.edition = Edition.current unless self.edition
  end

end
