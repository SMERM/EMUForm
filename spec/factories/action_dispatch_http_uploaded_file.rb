require_relative File.join('..', 'support', 'submitted_files_helper')

include SubmittedFilesHelper

FactoryGirl.define do

  factory :uploaded_file, class: ActionDispatch::Http::UploadedFile do

    transient do
      file_type          { get_file_type_to_submit }
    end

    original_filename    { get_file_to_submit(file_type) }
    content_type         { file_type.content_type }
    headers              { file_type.headers }
    tempfile do
      tf = Tempfile.new('EF_Test')
      FileUtils.cp(original_filename, tf.path)
      tf
    end

    #
    # remember that we can only use the +build+ method here because this is
    # not an ActiveRecord model
    #
    skip_create

    #
    # we add +File.basename(original_filename)+ instead of the full path
    # because this is actually what happens in forms. The full path is found
    # in tempfile which is the only accessible file for upload
    #
    initialize_with { new(:filename => File.basename(original_filename), :type => content_type, :head => headers, :tempfile => tempfile) }

  end

end
