#
# +Work+:
#
# represent a single work
#
class Work < ActiveRecord::Base

  validates_presence_of :title, :year, :duration, :instruments, :program_notes_en

  UPLOAD_BASE_PATH = File.join(Rails.root, 'public', 'private', 'uploads')
  UPLOAD_PREFIX = "EF#{Time.zone.now.year}_"
  UPLOAD_SUFFIX = ''

  #
  # <tt>new(args = {})
  #
  # If +Work+ is created without an <tt>args['directory']</tt> parameter, it
  # creates a directory using the +Dir::Tmpname.make_tmpname+ method.
  #
  def initialize(args = {})
    args['directory'] = Dir::Tmpname.make_tmpname(UPLOAD_PREFIX, UPLOAD_SUFFIX) unless args.has_key?('directory')
    Dir.mkdir(args['directory']) unless File.exists?(args['directory'])
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

private

  def year_anti_hystheresis(val)
    res = val.kind_of?(Time) ? val : Time.zone.parse(val.to_s)
    res + 2.days
  end

end
