class AuthorWorkRole < ActiveRecord::Base
  belongs_to :author
  belongs_to :work
  belongs_to :role
end
