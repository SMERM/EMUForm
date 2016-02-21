#
# +Work+:
#
# represent a single work
#
class Work < ActiveRecord::Base

  belongs_to :owner, class_name: 'Account'

  validates_presence_of :title, :year, :duration, :instruments, :program_notes_en, :owner_id

  has_many :submitted_files
  has_many :author_work_roles
  has_many :authors, -> { includes :roles }, through: :author_work_roles, source: :author
  has_many :roles, -> { includes :works }, through: :author_work_roles, source: :role

  accepts_nested_attributes_for :submitted_files, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:http_channel].blank? }
  accepts_nested_attributes_for :authors

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
  # <tt>display_roles(author)</tt> 
  #
  # display all the roles for a given author as a colon-separated list
  #
  def display_roles(author)
    self.roles.where('author_id = ?', author.to_param).uniq.map { |r| r.description }.sort.join(', ')
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
  # <tt>authors_with_roles(force = false)</tt>
  #
  # +authors_with_roles+:
  # * find all the relations between a work and an author (uniqe name)
  # * returns an array of hashes with the author id and a list of role ids for it
  #   like:
  #
  #   <tt>=> [{ :author_id => author_id, :roles_attributes => [ role_id, role_id, ...  ] }, { :author_id => .... } ]</tt>
  #
  def authors_with_roles(force = false)
    res = []
    as = self.authors(force).uniq
    as.each do
      |a|
      h = { :author_id => a.to_param }
      h.update(:roles_attributes => AuthorWorkRole.where('author_id = ? and work_id = ?', a.to_param, self.to_param).map { |awr| awr.role })
      res << h
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
    self.authors_with_roles(force).map do
      |awr|
      a = Author.find(awr[:author_id])
      awr_string = '%s (%s)' % [ a.full_name, self.display_roles(a) ]
      yield(awr_string, awr[:author_id])
    end 
  end

  #
  # <tt>update_all_roles(role_params_with_authors)</tt>
  #
  # updates the roles when editing a work for all authors
  # +role_params+ is an array of hashes with an +id:+ field, like this:
  # <tt>=> [ { author_id: '23', roles_attributes: [ { id: '1' }, { id: '2' }, ... ] } ]</tt>
  #
  # This method erases all previous roles and sets up new roles for each
  # author, which are to be saved *after* the work model is saved (that's when
  # it can be called by the controller).
  #
  def update_all_roles(role_params_with_authors)
    rpwa = role_params_with_authors.deep_dup
    raise ArgumentError, "the argument to Work#update_roles must be an Array (was a #{rpwa.class} instead)" unless rpwa.kind_of?(Array)
    rpwa.each do
      |el|
      el.stringify_keys!
      raise ArgumentError, "Elements of the argument to Work#update_all_roles must contain an ':author_id' and a ':roles_attributes' keys (#{el.inspect})" unless el.has_key?('author_id') && el.has_key?('roles_attributes')
      author = Author.find(el.delete('author_id'))
      self.update_roles_for_an_author(author, el)
    end
  end

  #
  # <tt>update_roles_for_an_author(author, role_params)</tt>
  #
  # updates the roles when editing a work for a given author
  # +role_params+ is a array of hashes each with an +id:+ field, like this:
  # <tt>=> [ { id: '1' }, { id: '2' }, ... ]</tt>
  #
  # This method erases all previous roles and sets up new roles for each
  # author, which are to be saved *after* the work model is saved (that's when
  # it can be called by the controller).
  #
  def update_roles_for_an_author(author, role_params)
    raise ArgumentError, "the second argument to Work#update_roles_for_an_author must be an Hash (was a #{role_params.class} instead)" unless role_params.kind_of?(Hash) && role_params.has_key?(:roles_attributes)
    rps = role_params[:roles_attributes]
    raise ArgumentError, "the value of the second argument to Work#update_roles_for_an_author must be an Array (was a #{rps.class} instead)" unless rps.kind_of?(Array)
    roles = []
    rps.each do
      |r|
      r.stringify_keys!
      raise ArgumentError, "Elements of the argument to Work#update_roles_for_an_author must be Hashes and contain an ':id' key (#{r.inspect})" unless r.kind_of?(Hash) && r.has_key?('id')
      roles << Role.find(r['id']) unless r['id'].blank?
    end
    self.detach_an_author(author)
    self.add_author_with_roles(author, roles)
  end

  #
  # <tt>update_extra_features(authors_with_roles, submitted_files = {})</tt>
  #
  # +update_extra_features+ performs all extra functionality-related duties
  # when saving or updating a +Work+ object for a given author.
  #
  # After performing all duties this function reloads the model.
  #
  def update_extra_features(authors, roles, submitted_files)
    self.add_submitted_files(submitted_files) unless submitted_files[:submitted_files_attributes].blank?
    self.update_all_roles(authors_with_roles) unless roles[:roles_attributes].blank?
    self.reload
  end

  class << self

    #
    # <tt>clean_args(args)</tt>
    #
    # returns the input arguments without the `authors_attributes`,
    # `roles_attributes` and `submitted_files_attributes` args in
    # order to save the object first. The latter can be added with the
    # `update_roles` method explained above.
    #
    # It returns an array with four elements:
    # * the cleaned up args
    # * the authors
    # * the roles
    # * the submitted files
    #
    def clean_args(args)
      raise ArgumentError, "argument #{args} is not a Hash or doesn't have a 'work' key" unless args.kind_of?(Hash) && args.has_key?('work')
      cargs = args.dup
      authors = prepare_for_permission(cargs, :authors_attributes)
      roles   = prepare_for_permission(cargs, :roles_attributes)
      submitted_files = prepare_for_permission(cargs, :submitted_files_attributes)
      [cargs, authors, roles, submitted_files]
    end

    #
    # <tt>add_author_with_role(w_id, a_id, r_id)</tt>
    #
    # adds a three-way link between a work, an author and a role (class
    # method)
    #
    def add_author_with_role(w_id, a_id, r_id)
      AuthorWorkRole.create(:author_id => a_id, :work_id => w_id, :role_id => r_id)
    end
  
    #
    # <tt>detach_role_from_an_author(w_id, a_id, r_id)</tt>
    #
    # removes a three-way link between an author, a work and a role (class
    # method). This does not destroy any of the linked records (author, work,
    # or role).
    #
    def detach_role_from_an_author(w_id, a_id, r_id)
      awr = AuthorWorkRole.where("author_id = #{a_id} and work_id = #{w_id} and role_id = #{r_id}").first
      awr.valid? && awr.destroy
      awr
    end

    #
    # <tt>detach_an_author(a_id, w_id)</tt>
    #
    # removes all three-way links between an author and a work (class method).
    # This does not destroy any of the linked records (author, work,
    # or role), but just any connection between an author and a work.
    #
    def detach_an_author(a_id, w_id)
      AuthorWorkRole.destroy_all("author_id = #{a_id} and work_id = #{w_id}") if a_id && w_id
    end

  private

    def prepare_for_permission(args, key)
      ActionController::Parameters.new(:work => { key => args[:work].delete(key) })
    end

  end

  #
  # <tt>add_author_with_roles(author, role)</tt>
  #
  # adds all the three-way links between an author, a work and the roles of the author (instance
  # method)
  #
  def add_author_with_roles(a, rs)
    rs = [ rs ] unless rs.kind_of?(Array)
    rs.each { |r| self.class.add_author_with_role(self.to_param, a.to_param, r.to_param) }
  end

  #
  # <tt>detach_role_from_an_author(author, role)</tt>
  #
  # removes a three-way link between a work, an author and a role (instance
  # method). This does not destroy any of the linked records (author, work,
  # or role).
  #
  def detach_role_from_an_author(a, r)
    self.class.detach_role_from_an_author(self.to_param, a.to_param, r.to_param)
  end

  #
  # <tt>detach_an_author(author)</tt>
  #
  # removes all three-way links between a work and an author (instance method).
  # This does not destroy any of the linked records (author, work,
  # or role), but just any connection between an author and a work.
  #
  def detach_an_author(author)
    self.class.detach_an_author(self.to_param, author.to_param)
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
