class Author < ActiveRecord::Base

  has_and_belongs_to_many :works
  before_destroy { works.clear } # we do not destroy the works because they might belong to another author

  validates_presence_of :first_name, :last_name

end
