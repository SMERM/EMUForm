require 'rails_helper'
require_relative File.join('..', 'support', 'submitted_files_helper')

RSpec.describe SubmittedFile, type: :model do

  include SubmittedFilesHelper

  before :example do
    @work = FactoryGirl.create(:work)
    @http_request = FactoryGirl.create(:uploaded_file)
    @mime_types = { '.mp3' => 'audio/mpeg', '.wav' => 'audio/x-wav', '.pdf' => 'application/pdf' }
    @headers = 'Content-Disposition: form-data'
    @mime_type = @mime_types[file_suffix(@http_request.original_filename)]
  end

  context 'object creation and destruction' do

    it 'cannot be created through the usual creation path' do
      expect { SubmittedFile.new }.to raise_error(NoMethodError)
      expect { SubmittedFile.create }.to raise_error(NoMethodError)
      expect { SubmittedFile.create! }.to raise_error(NoMethodError)
      expect { SubmittedFile.new_from_http_request }.to raise_error(NoMethodError)
      expect { SubmittedFile.create_from_http_request }.to raise_error(NoMethodError)
    end

    it 'cleans up after itself upon destruction' do
      expect((sf = FactoryGirl.create(:submitted_file, work: @work)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(File.exists?(sf.attached_file_full_path)).to be(true)
      sf.destroy
      expect(sf.frozen?).to be(true)
      expect(File.exists?(sf.attached_file_full_path)).to be(false)
      clean_up(sf)
    end

  end

  context 'file uploading' do

    it 'does indeed upload the file (at least local -> local)' do
      expect((sf = FactoryGirl.create(:submitted_file)).valid?).to be(true), sf.errors.full_messages.join(', ')
      expect(File.exists?(sf.attached_file_full_path)).to be(true)
      expect(File.size(sf.attached_file_full_path)).to eq(sf.size)
      clean_up(sf)
    end

  end

  def file_suffix(filename)
    ridx = filename.rindex('.')
    filename[ridx..-1]
  end

end
