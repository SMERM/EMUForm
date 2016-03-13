class Forgery::Emuform < Forgery

  #
  # select a random title from the `work_titles` dictionary
  #
  def self.title()
    dictionaries[:work_titles].random.unextend
  end

end

