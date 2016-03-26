class Category < ActiveRecord::Base

  has_and_belongs_to_many :editions

  validates_presence_of   :acro, :title_en, :title_it, :description_en, :description_it
  validates_uniqueness_of :acro

  #
  # +full_title+
  #
  # combines the acro along with the english title
  #
  def full_title
    [self.acro, self.title_en].join(': ')
  end

end
