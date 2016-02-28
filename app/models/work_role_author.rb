class WorkRoleAuthor < ActiveRecord::Base

  belongs_to :work
  belongs_to :role
  belongs_to :author

end
