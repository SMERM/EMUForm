class SubmittedFile < ActiveRecord::Base

  belongs_to :work

  validates_presence_of :filename, :content_type, :remote_source, :size, :work_id

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
    def create(args = {})
      raise ArgumentError, "args is not a Hash but rather a #{args.class}" unless args.kind_of?(Hash)
      raise ArgumentError, "args (#{args.inspect}) does not contain an :http_channel field" unless args.has_key?(:http_channel)
      raise ArgumentError, "The :http_channel field is not an ActionDispatch::Http::UploadedFile but rather a #{args.class}" unless args[:http_channel].kind_of?(ActionDispatch::Http::UploadedFile)
      http_channel = args.delete(:http_channel)
      args[:filename] = http_channel.original_filename
      args[:content_type] = http_channel.content_type
      args[:size] = http_channel.size
      args[:remote_source] = http_channel.tempfile
      me = super(args)
      me.http_channel = http_channel
      me
    end

  end

end
