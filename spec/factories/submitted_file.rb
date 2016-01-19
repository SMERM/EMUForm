FactoryGirl.define do

  factory :submitted_file do

    association         :work
    
    transient do
      http_channel        { FactoryGirl.build(:uploaded_file) }
      actual_args         { SubmittedFile.send(:patch_arguments, { :http_channel => http_channel, :work => work }) }
    end

    filename              { actual_args[:filename] }
    content_type          { actual_args[:content_type] }
    size                  { actual_args[:size] }

    after :build do
      |sf, evaluator|
      sf.http_channel = evaluator.http_channel
    end

  end

end
