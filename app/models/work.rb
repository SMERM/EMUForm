#
# +Work+:
#
# represent a single work
#
class Work < ActiveRecord::Base

  belongs_to :owner, class_name: 'Account'

  validates_presence_of :title, :year, :duration, :instruments, :program_notes_en, :owner_id

  has_many :submitted_files
  has_many :works_roles_authors
  has_many :authors, through: :works_roles_authors, dependent: :destroy

  accepts_nested_attributes_for :submitted_files, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:http_channel].blank? }
  accepts_nested_attributes_for :authors

  UPLOAD_COND_PATH = Rails.env == 'test' ? 'spec' : 'public'
  UPLOAD_BASE_PATH = File.join(Rails.root, UPLOAD_COND_PATH, 'private', 'uploads')
  UPLOAD_PREFIX = "EF#{Time.zone.now.year}_"
  UPLOAD_SUFFIX = ''

  #
  # +authors_attributes=(attrs)+ + +after_save+
  #
  # overrides the default in order to take care of the three-way many-to-many
  # relationship between work, roles and authors.
  #
  # This prepares the records which are saved at a later time through the
  # +after_save+ callback +:create_authors_roles_links+
  #
  # It clears the all the previous attributions (if any) so that the work
  # record may be updated.
  #
  after_save :create_authors_roles_links

  def authors_attributes=(attrs)
    @_wras_ = []
    attrs.each do
      |h|
      h[:roles_attributes].each do
        |rh|
        # add only if rh[:id] is actually present (view adds an empty one at the end)
        @_wras_ << WorkRoleAuthor.new(author_id: h[:id], role_id: rh[:id]) unless rh[:id].blank?
      end
    end
    @_wras_
  end

  #
  # +submitted_files_attributes=(attrs)+ + +after_save+
  #
  # This prepares the records which are saved at a later time through the
  # +after_save+ callback +:create_submitted_files_links+
  #
  after_save :create_submitted_files_links

  def submitted_files_attributes=(attrs)
    @_sfs_ = attrs
  end

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
  # +before_destroy+ clears the directory containing the media
  #
  before_destroy :clear_directory

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
  # +add_submitted_files(sf_attributes)+
  #
  # add an array of submitted files which is enclosed in a hash with key
  # :submitted_file_attributes
  #
  def add_submitted_files(sf_attributes)
    raise ArgumentError, "add_submitted_files(#{File.basename(__FILE__)}:#{__LINE__}) requires a hash argument and got a \"#{sf_attributes.inspect}\" instead" unless sf_attributes.kind_of?(Hash) && sf_attributes.has_key?(:submitted_files_attributes)
    sfs = sf_attributes[:submitted_files_attributes]
    raise ArgumentError, "The submitted files attributes should be an array and it is a #{sfs.class.name} instead" unless sfs.kind_of?(Array)
    sfs.each do
      |att|
      att.update(:work => self)
      sf = SubmittedFile.create(att)
      sf.upload
    end
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

  #
  # <tt>display_authors_with_roles(force = false)</tt>
  #
  # creates a string with authors and roles in the form:
  #
  # `Evelyn Fernandez (Music Composer, Text Author), Sheila Shanti (Video Director), ...`
  #
  def display_authors_with_roles(force = false)
    self.authors(force).uniq.map { |a| '%s (%s)' % [ a.full_name, a.roles(force).for_work(self.to_param).uniq.map { |r| r.description }.join(', ') ] }.join(', ')
  end

  #
  # <tt>upload_submitted_files</tt>
  #
  # +upload_submitted_files+ uploads all files from the remote (user) machine
  # to the local (server-side) repository
  #
  # It returns `true` upon success or `false` upon failure
  #
  def upload_submitted_files
    res = true
    begin
      self.submitted_files.each { |sf| sf.upload }
    rescue
      res = false
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

  def create_authors_roles_links
    unless @_wras_.blank?
      @_wras_.each do
        |wra|
        wra.update(work_id: self.to_param)
        wra.save
      end
    end
  end

  def create_submitted_files_links
    @_sfs_.each { |sf_args| SubmittedFile.create_from_file(sf_args[:filename], self) } unless @_sfs_.blank?
  end

end
