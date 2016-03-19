require 'filemagic'

class SubmittedFile < ActiveRecord::Base

  belongs_to :work

  #
  # the real db properties of +SubmittedFile+ are
  #
  # * work_id
  # * filename
  # * content_type
  # * size
  #
  validates_presence_of :work_id

  #
  # we should avoid to create a SubmittedFile via the usual methods (:new and
  # :create) so we privatize them
  #
  private_class_method :new, :create, :create!

  class << self

    #
    # <tt>new_from_file(filename, work)</tt>
    #
    # +SubmittedFile+ does not get initialized in the usual way (directely from
    # a form but, rather, it is initialized with a filename and a
    # +Work+ reference object. As such, its creation is a bit uncommon.
    #
    def new_from_file(filename, work)
      (content_type, size) = set_size_and_content_type(filename)
      args = { filename: filename, work_id: work.to_param, content_type: content_type, size: size }
      new(args)
    end

    #
    # <tt>create_from_file(filename, work)</tt>
    #
    # +SubmittedFile+ does not get created in the usual way (directely from
    # a form but, rather, it is created with a filename and a
    # +Work+ reference object. As such, its creation is a bit uncommon.
    #
    def create_from_file(filename, work)
      obj = new_from_file(filename, work)
      obj.save
      obj
    end

  private

    def set_size_and_content_type(filename)
      size = File.size(filename)
      content_type = FileMagic.open(:mime) { |fm| fm.file(filename) }
      [ content_type, size ]
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
    w = self.work
    super
    File.unlink(self.attached_file_full_path) if File.exists?(self.attached_file_full_path)
  end

  #
  # +upload+
  #
  # it actually performs the upload of the file from the remote location into
  # the server-side repository (overwriting the server-side file if it exists)
  #
  UPLOAD_CHUNK = 1024000 # TODO: to be tuned
  def upload
    tf = Tempfile.new('EF_Test')
    FileUtils.cp(self.filename, tf.path)
    hc = ActionDispatch::Http::UploadedFile.new(filename: self.filename, content_type: self.content_type, size: self.size, tempfile: tf)
    File.open(self.attached_file_full_path, 'wb') do
      |wh|
      hc.open
      while(!hc.tempfile.eof?)
        wh.write(hc.read(UPLOAD_CHUNK))
      end
    end
    hc.close
    tf.close
  end

end
