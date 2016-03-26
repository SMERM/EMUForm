class Category < ActiveRecord::Base

  validates_presence_of   :acro, :title_en, :title_it, :description_en, :description_it
  validates_uniqueness_of :acro

end
