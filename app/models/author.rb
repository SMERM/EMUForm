class Author < ActiveRecord::Base

  has_and_belongs_to_many :works
  before_destroy :handle_destruction_of_associated_works

  validates_presence_of :first_name, :last_name

  def full_name
    [self.first_name, self.last_name].join(' ')
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
