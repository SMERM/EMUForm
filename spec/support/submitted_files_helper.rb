module SubmittedFilesHelper

  FIXTURES_PATH       = File.expand_path(File.join(['..'] * 2, 'fixtures'), __FILE__)
  AUDIO_FIXTURES_PATH = File.join(FIXTURES_PATH, 'audio')
  DOC_FIXTURES_PATH   = File.join(FIXTURES_PATH, 'doc')
  TMPDIR              = ENV['TMP'] || '/tmp'

  class FileType

    attr_reader :suffix, :path, :type, :content_type, :headers

    def initialize(s, p, t, ct, h)
      @suffix = s
      @path = p
      @type = t
      @content_type = ct
      @headers = h
    end

  end

  ORIG_FILES =
  [
    FileType.new('.wav', AUDIO_FIXTURES_PATH, 'audio', 'audio/x-wav', 'Content-Disposition: form-data'),
    FileType.new('.mp3', AUDIO_FIXTURES_PATH, 'audio', 'audio/mpeg', 'Content-Disposition: form-data'),
    FileType.new('.pdf', DOC_FIXTURES_PATH, 'doc', 'application/pdf', 'Content-Disposition: form-data'),
  ]

  def get_file_type_to_submit
    idx = Forgery(:basic).number(at_least: 0, at_most: ORIG_FILES.size - 1)
    ORIG_FILES[idx]
  end

  def get_file_to_submit(orig_file = nil)
    ft = orig_file ? orig_file : get_file_type_to_submit
    src = File.join(ft.path, 'test' + ft.suffix)
    res = Dir::Tmpname.make_tmpname(["spec_request_#{ft.type}_test", ft.suffix], 23)
    res = [TMPDIR, res].join('/')
    FileUtils.ln(src, res, force: true)    
    res
  end

  def get_an_http_request_to_submit
    ftype = get_file_type_to_submit
    orig_file = get_file_to_submit(ftype)
    FactoryGirl.build(:uploaded_file, original_filename: orig_file, content_type: ftype.content_type, headers: ftype.headers)
  end

  def create_submitted_files(n)
    common_submitted_files(n) { |hr, w| FactoryGirl.create(:submitted_file, http_request: hr, work: w) }
  end

  def build_submitted_files(n)
    common_submitted_files(n) { |hr, w| FactoryGirl.build(:submitted_file, http_request: hr, work: w) }
  end

  #
  # <tt>clean_up(submitted_file)</tt>
  #
  # cleans up all testing created files
  #
  def clean_up(sf)
    File.unlink(sf.filename) if File.exists?(sf.filename)
    File.unlink(sf.attached_file_full_path) if File.exists?(sf.attached_file_full_path)
  end

private

  def common_submitted_files(n)
    res = []
    1.upto(n) do
     |x|
     hr = get_an_http_request_to_submit
     res << yield(hr, @work)
    end
    res
  end

end
