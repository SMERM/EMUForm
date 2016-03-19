require 'rails_helper'
require_relative File.join('..', 'support', 'submitted_files_builder')

RSpec.describe SubmittedFile, type: :model do

  context 'object creation and destruction' do

    include SubmittedFilesBuilder

    before :example do
      @work = FactoryGirl.create(:work)
      @file = get_file_to_submit
      @filename = @file.path
      @mime_types = { '.mp3' => 'audio/mpeg; charset=binary', '.wav' => 'audio/x-wav; charset=binary', '.pdf' => 'application/pdf; charset=binary' }
      @mime_type = @mime_types[file_suffix(@filename)]
    end

    it 'cannot be created through the usual creation path' do
      expect { SubmittedFile.new }.to raise_error(NoMethodError)
      expect { SubmittedFile.create }.to raise_error(NoMethodError)
      expect { SubmittedFile.create! }.to raise_error(NoMethodError)
    end

    it 'can be created with a file and a Work object' do
      expect((sf = SubmittedFile.create_from_file(@filename, @work)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(sf.new_record?).to be(false)
      expect(@work.submitted_files.include?(sf)).to be(true)
      expect(sf.content_type).to eq(@mime_type)
    end

    it 'can be built with a file and a Work object' do
      expect((sf = SubmittedFile.new_from_file(@filename, @work)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(sf.new_record?).to be(true)
    end

    it 'can be created through a FactoryGirl create process' do
      expect((sf = FactoryGirl.create(:submitted_file, work: @work)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(@work.submitted_files.include?(sf)).to be(true)
    end

    it 'can be built through a FactoryGirl build process' do
      expect((sf = FactoryGirl.build(:submitted_file, work: @work)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(sf.new_record?).to be(true)
    end

    it 'cleans up after itself upon destruction' do
      expect((sf = FactoryGirl.create(:submitted_file, work: @work)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect((affp = sf.attached_file_full_path).blank?).to be(false)
      expect(sf.destroy).to be(nil)
      expect(sf.frozen?).to be(true)
      expect(File.exists?(affp)).to be(false)
    end

  end

  context 'file uploading' do

    it 'does indeed upload the file (at least local -> local)' do
      expect((sf = FactoryGirl.create(:submitted_file)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(File.exists?(sf.attached_file_full_path)).to be(false)
      #
      sf.upload
      expect(File.exists?(sf.attached_file_full_path)).to be(true)
      expect(File.size(sf.attached_file_full_path)).to eq(sf.size)
    end

  end

  def file_suffix(filename)
    ridx = filename.rindex('.')
    filename[ridx..-1]
  end

end
