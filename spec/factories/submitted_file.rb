FactoryGirl.define do

  factory :submitted_file do

    association         :work
    
    transient do
      http_request        { FactoryGirl.build(:uploaded_file) }
      actual_args         { SubmittedFile.send(:patch_arguments, { :http_request => http_request, :work => work }) }
    end

    filename              { actual_args[:filename] }
    content_type          { actual_args[:content_type] }
    size                  { actual_args[:size] }

    after :build do
      |sf, evaluator|
      sf.http_request = evaluator.http_request
    end

    #
    # +:submitted_file_without_association+ expects the work_id to be set on
    # its argument
    #
    factory :submitted_file_without_association do

      work_id              nil

      before :build do
        |sf, evaluator|
        sf.work.destroy if sf.work && sf.work.valid?
      end

    end

  end

end
