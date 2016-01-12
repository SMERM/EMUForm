class Work < ActiveRecord::Base

  validates_presence_of :title, :year, :duration, :instruments, :program_notes_en

end
