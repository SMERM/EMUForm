class AuthorWork < ActiveRecord::Base
  has_and_belongs_to_many :role
  belongs_to :author
  belongs_to :work
end
