FactoryGirl.define do

  factory :submitted_file do

    transient do
      http_request       { FactoryGirl.build(:uploaded_file) }
      work               { FactoryGirl.create(:work) }
    end

    initialize_with      { SubmittedFile.upload(http_request, work) }
 
  end

end
