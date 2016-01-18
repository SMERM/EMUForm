require 'rails_helper'

RSpec.describe SubmittedFile, type: :model do

  context 'object creation' do

    it 'can be created with an ActionDispatch::Http::UploadedFile object and a Work object' do
      expect((w = FactoryGirl.create(:work)).valid?).to be(true)
      expect((src = FactoryGirl.build(:uploaded_file)).kind_of?(ActionDispatch::Http::UploadedFile)).to be(true)
      expect((args = { :http_channel => src, :work => w }).kind_of?(Hash)).to be(true)
      expect((sf = SubmittedFile.create(args)).valid?).to eq(true)
    end

  end

end
