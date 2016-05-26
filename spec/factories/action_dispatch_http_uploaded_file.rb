require_relative File.join('..', 'support', 'submitted_files_helper')

include SubmittedFilesHelper

FactoryGirl.define do

  factory :uploaded_file, class: ActionDispatch::Http::UploadedFile do

    transient do
      test_file_name     TestFile::DEFAULT_TEST_FILENAME
      test_file          { get_file_to_submit(test_file_name) }
    end

    content_type         { test_file.file_type.content_type }
    headers              { test_file.file_type.headers }
    tempfile do
      tf = Tempfile.new('EF_Test')
      FileUtils.cp(test_file.filename_full_path, tf.path)
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
    initialize_with { new(:filename => test_file.basename, :type => content_type, :head => headers, :tempfile => tempfile) }

  end

end
