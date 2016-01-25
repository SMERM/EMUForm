#
# +Work+:
#
# represent a single work
#
class Work < ActiveRecord::Base

  validates_presence_of :title, :year, :duration, :instruments, :program_notes_en

  has_many :submitted_files
  has_many :author_works
  has_many :authors, :through => :author_works, :source => Author

  accepts_nested_attributes_for :submitted_files, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:http_channel].blank? }

  UPLOAD_COND_PATH = Rails.env == 'test' ? 'spec' : 'public'
  UPLOAD_BASE_PATH = File.join(Rails.root, UPLOAD_COND_PATH, 'private', 'uploads')
  UPLOAD_PREFIX = "EF#{Time.zone.now.year}_"
  UPLOAD_SUFFIX = ''

  #
  # +after_validation+
  #
  # The +create_directory+ is called after validation is passed to generate
  # the proper landing directory for all submitted files.
  # If +Work+ is created without an <tt>args['directory']</tt> parameter, it
  # creates a directory using the +Dir::Tmpname.make_tmpname+ method
  #
  after_validation :create_directory

  #
  # +destroy+ will remove the record and the file directory
  #
  def destroy
    self.clear_directory
    super
  end

  #
  # displaying these attribute requires some conditioning
  #
  # +display_duration+ should be in the form hh:mm:ss
  #
  def display_duration
    res = self.duration
    res.kind_of?(Time) ?  res.strftime("%H:%M:%S") : ''
  end

  #
  # +display_year+ should be in the form yyyy
  #
  def display_year
    res = self.year
    res.kind_of?(Time) ? res.year : ''
  end

  #
  # +year=+ when actually writing a composition year, since inserting a single
  # year has an hysteresis connect to local time zones we should add a couple
  # of days to it to make sure we get the proper year set
  #
  def year=(val)
    write_attribute(:year, year_anti_hystheresis(val))
  end

  #
  # +clear_directory+ will remove the directory referenced by the object,
  # if present, and clear the field. It returns the removed directory
  #
  def clear_directory
    res = nil
    unless self.directory.blank?
      res = self.directory
      FileUtils.rm_rf(self.directory, :secure => true)
      self.directory = nil
    end
    res
  end

private

  def create_directory
    self.directory = Dir::Tmpname.make_tmpname(File.join(UPLOAD_BASE_PATH, UPLOAD_PREFIX), UPLOAD_SUFFIX) unless self.directory
    FileUtils.mkdir_p(self.directory)
  end

  def year_anti_hystheresis(val)
    res = val.kind_of?(Time) ? val : Time.zone.parse(val.to_s)
    res + 2.days
  end

end
