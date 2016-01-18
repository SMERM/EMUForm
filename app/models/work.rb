#
# +Work+:
#
# represent a single work
#
class Work < ActiveRecord::Base

  validates_presence_of :title, :year, :duration, :instruments, :program_notes_en

  has_many :submitted_files

  UPLOAD_BASE_PATH = File.join(Rails.root, 'public', 'private', 'uploads', Rails.env)
  UPLOAD_PREFIX = "EF#{Time.zone.now.year}_"
  UPLOAD_SUFFIX = ''

  #
  # <tt>new(args = {})
  #
  # If +Work+ is created without an <tt>args['directory']</tt> parameter, it
  # creates a directory using the +Dir::Tmpname.make_tmpname+ method and then
  # uploads all its files
  #
  def initialize(args = {})
    super
    create_directory(args) if self.valid? # should create the directory only if record is valid
  end

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
      self.update_attributes!(:directory => nil)
    end
    res
  end

private

  def create_directory(args)
    self.directory = Dir::Tmpname.make_tmpname(File.join(UPLOAD_BASE_PATH, UPLOAD_PREFIX), UPLOAD_SUFFIX) unless args.has_key?('directory')
    FileUtils.mkdir_p(self.directory)
  end

  def year_anti_hystheresis(val)
    res = val.kind_of?(Time) ? val : Time.zone.parse(val.to_s)
    res + 2.days
  end

end
