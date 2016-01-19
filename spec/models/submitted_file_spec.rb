require 'rails_helper'

RSpec.describe SubmittedFile, type: :model do

  context 'object creation and destruction' do

    it 'can be created with an ActionDispatch::Http::UploadedFile object and a Work object' do
      expect((w = FactoryGirl.create(:work)).valid?).to be(true)
      expect((src = FactoryGirl.build(:uploaded_file)).kind_of?(ActionDispatch::Http::UploadedFile)).to be(true)
      expect((args = { :http_channel => src, :work => w }).kind_of?(Hash)).to be(true)
      expect((sf = SubmittedFile.create(args)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(sf.http_channel).to eq(src)
    end

    it 'can be created through a FactoryGirl create process' do
      expect((sf = FactoryGirl.create(:submitted_file)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(sf.stale?).to be(false)
    end

    it 'cleans up after itself upon destruction' do
      expect((sf = FactoryGirl.create(:submitted_file)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect((affp = sf.attached_file_full_path).blank?).to be(false)
      expect(sf.destroy).to be(nil)
      expect(sf.frozen?).to be(true)
      expect(File.exists?(affp)).to be(false)
    end

  end

  context 'file uploading' do

    it 'does indeed upload the file (at least local -> local)' do
      expect((sf = FactoryGirl.create(:submitted_file)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(sf.stale?).to be(false)
      expect(File.exists?(sf.http_channel.path)).to be(true)
      expect(File.exists?(sf.attached_file_full_path)).to be(false)
      #
      sf.upload
      expect(File.exists?(sf.attached_file_full_path)).to be(true)
      expect(File.stat(sf.attached_file_full_path).size).to eq(sf.http_channel.size)
    end

  end

  context 'attribute checking' do

  end

end
