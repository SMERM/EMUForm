class SubmittedFile < ActiveRecord::Base

  belongs_to :work

  #
  # the real db properties of +SubmittedFile+ are
  #
  # * work_id
  # * filename
  # * content_type
  # * headers
  # * size
  #
  # All these properties are initialized through the specialized constructors
  # (see below).
  #
  validates_presence_of :work_id

  #
  # we should avoid to create a SubmittedFile via the usual methods (:new and
  # :create) so we privatize them
  #
  private_class_method :new, :create, :create!

  class << self

    #
    # <tt>upload(http_request, work)</tt>
    #
    # because of the way +SubmittedFile+ objects are created, they get a
    # different constructor that also +uploads+ the file. It's the only way to
    # both create and update the file
    #
    # TODO: deal with updates
    #
    def upload(http_request, work)
      obj = create_from_http_request(http_request, work)
      obj.upload(http_request)
      obj
    end

  private

    def new_from_http_request(hr, work)
      raise ArgumentError, "First argument is expected to be an ActionDispatch::Http::UploadedFile (was: #{hr.class.name})" unless hr.kind_of?(ActionDispatch::Http::UploadedFile)
      args = { filename: hr.original_filename, work: work, content_type: hr.content_type, headers: hr.headers, size: hr.size, }
      new(args)
    end

    def create_from_http_request(hr, work)
      obj = new_from_http_request(hr, work)
      raise ActiveRecord::RecordInvalid, obj unless obj.valid?
      obj.save
      obj
    end

  end

  #
  # +attached_file_full_path+
  #
  # returns the full (server) path of the attached file
  #
  def attached_file_full_path
    File.join(self.work.directory, File.basename(self.filename))
  end

  #
  # +destroy+
  #
  # needs to make some file cleanup after calling its +super+
  # +destroy+ removes the uploaded file from its tree.
  #
  def destroy
    File.unlink(self.attached_file_full_path) if File.exists?(self.attached_file_full_path)
    super
  end

  #
  # +upload(http_request)+
  #
  # it actually performs the upload of the file from the remote location into
  # the server-side repository (overwriting the server-side file if it exists)
  #
  UPLOAD_CHUNK = 1024000 # TODO: to be tuned
  def upload(http_request)
    hr = http_request
    File.open(self.attached_file_full_path, 'wb') do
      |wh|
      hr.open
      while(!hr.tempfile.eof?)
        wh.write(hr.read(UPLOAD_CHUNK))
      end
    end
    hr.close
  end

end
