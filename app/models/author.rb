class Author < ActiveRecord::Base

  has_and_belongs_to_many :works

  validates_presence_of :first_name, :last_name

end
