class SubmittedFile < ActiveRecord::Base

  belongs_to :work

  validates_presence_of :filename, :content_type, :size, :work_id

  attr_accessor :http_channel

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
    # * +:http_channel+: the +ActionDispatch::Http::FileUploader+ object
    # * +:work+: the +Work+ object reference
    #
    # The +http_channel+ object is not persisted in the database. As such, the
    # +upload+ method will only work during the lifetime of the object, and
    # after it will enter into a `stale` state
    #
    def create(args = {})
      http_channel = args[:http_channel]
      final_args = patch_arguments(args)
      me = super(final_args)
      me.http_channel = http_channel
      me
    end

  private

    #
    # <tt>patch_arguments(args)</tt>
    #
    # performs the actual ugly work
    #
    def patch_arguments(args)
      raise ArgumentError, "args is not a Hash but rather a #{args.class}" unless args.kind_of?(Hash)
      raise ArgumentError, "args (#{args.inspect}) does not contain an :http_channel field" unless args.has_key?(:http_channel)
      raise ArgumentError, "The :http_channel field is not an ActionDispatch::Http::UploadedFile but rather a #{args.class}" unless args[:http_channel].kind_of?(ActionDispatch::Http::UploadedFile)
      res = args.dup
      http_channel = res.delete(:http_channel)
      res.update(:filename => File.basename(http_channel.original_filename), :content_type => http_channel.content_type, :size => http_channel.size)
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
    hc = self.http_channel
    File.open(self.attached_file_full_path, 'w') do
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
  # if the object does not have an +http_channel+ any longer, it means that it
  # comes from the database and has lost the link to the original remote
  # source
  #
  def stale?
    self.http_channel.nil?
  end

end
