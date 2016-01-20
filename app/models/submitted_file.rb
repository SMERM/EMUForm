class SubmittedFile < ActiveRecord::Base

  belongs_to :work

  #
  # the real db properties of +SubmittedFile+ are
  #
  # * filename
  # * content_type
  # * size
  #
  # but these arguments are all set automatically from an +http_request+ object
  #
  validates_presence_of :http_request, :work_id

  attr_accessor :http_request

  class << self

    #
    # <tt>create(args = {})</tt>
    #
    # +SubmittedFile+ does not get initialized in the usual way (directely from
    # a form but, rather, it is initialized from an
    # +ActionDispatch::Http::FileUploader+ object (which comes from a form) and a
    # +Work+ reference object. As such, its creation is a bit uncommon.
    #
    # The argument is the usual Hash but it must have the following fields set:
    #
    # * +:http_request+: the +ActionDispatch::Http::FileUploader+ object
    # * +:work+: the +Work+ object reference
    #
    # The +http_request+ object is not persisted in the database. As such, the
    # +upload+ method will only work during the lifetime of the object, and
    # after it will enter into a `stale` state
    #
    def create(args = {})
      final_args = patch_arguments(args)
      super(final_args)
    end

  private

    #
    # <tt>patch_arguments(args)</tt>
    #
    # performs the actual ugly work
    #
    def patch_arguments(args)
      raise ArgumentError, "args is not a Hash but rather a #{args.class}" unless args.kind_of?(Hash)
      raise ArgumentError, "args (#{args.inspect}) does not contain an :http_request field" unless args.has_key?(:http_request)
      raise ArgumentError, "The :http_request field is not an ActionDispatch::Http::UploadedFile but rather a #{args.class}" unless args[:http_request].kind_of?(ActionDispatch::Http::UploadedFile)
      hr = args[:http_request]
      res = args.dup
      res.update(:filename => File.basename(hr.original_filename), :content_type => hr.content_type, :size => hr.size)
      res
    end

  end

  #
  # +attached_file_full_path+
  #
  # returns the full path of the attached file (caching it the first time)
  #
  def attached_file_full_path
    @affp ||= File.join(self.work.directory, self.filename)
  end

  #
  # +destroy+
  #
  # needs to make some file cleanup after calling its +super+
  # +destroy+ removes the uploaded file from its tree.
  #
  def destroy
    w = self.work
    super
    File.unlink(self.attached_file_full_path) if File.exists?(self.attached_file_full_path)
  end

  class CantUploadAStaleSubmittedFile < StandardError; end
  #
  # +upload+
  #
  # it actually performs the upload of the file from the remote location into
  # the repository (overwriting the local file if it exists)
  #
  UPLOAD_CHUNK = 1024000 # TODO: to be tuned
  def upload
    raise CantUploadAStaleSubmittedFile if self.stale?
    hc = self.http_request
    File.open(self.attached_file_full_path, 'wb') do
      |wh|
      hc.open
      while(!hc.tempfile.eof?)
        wh.write(hc.read(UPLOAD_CHUNK))
      end
    end
    hc.close
  end

  #
  # +stale?+
  #
  # if the object does not have an +http_request+ any longer, it means that it
  # comes from the database and has lost the link to the original remote
  # source
  #
  def stale?
    self.http_request.nil?
  end

end
