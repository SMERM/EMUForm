require_relative File.join('..', 'support', 'submitted_files_builder')

include SubmittedFilesBuilder

FactoryGirl.define do

  factory :submitted_file do

    filename             { get_file_to_submit.path }
    work                 { FactoryGirl.create(:work) }

    initialize_with      { SubmittedFile.new_from_file(filename, work) }
 
  end

end
