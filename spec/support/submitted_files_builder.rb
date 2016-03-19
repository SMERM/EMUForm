module SubmittedFilesBuilder

  FIXTURES_PATH       = File.expand_path(File.join(['..'] * 2, 'fixtures'), __FILE__)
  AUDIO_FIXTURES_PATH = File.join(FIXTURES_PATH, 'audio')
  DOC_FIXTURES_PATH   = File.join(FIXTURES_PATH, 'doc')

  class FileType

    attr_reader :suffix, :path, :type

    def initialize(s, p, t)
      @suffix = s
      @path = p
      @type = t
    end

  end

  ORIG_FILES =
  [
    FileType.new('.wav', AUDIO_FIXTURES_PATH, 'audio'),
    FileType.new('.mp3', AUDIO_FIXTURES_PATH, 'audio'),
    FileType.new('.pdf', DOC_FIXTURES_PATH, 'doc'),
  ]

  def get_file_to_submit
    idx = Forgery(:basic).number(at_least: 0, at_most: ORIG_FILES.size - 1)
    orig_file = ORIG_FILES[idx]
    src = File.join(orig_file.path, 'test' + orig_file.suffix)
    res = Tempfile.new(["spec_request_#{orig_file.type}_test", orig_file.suffix])
    FileUtils.ln(src, res, force: true)    
    res
  end

  def create_submitted_files(n)
    common_submitted_files(n) { |f, w| FactoryGirl.create(:submitted_file, filename: f, work: w) }
  end

  def build_submitted_files(n)
    common_submitted_files(n) { |f, w| FactoryGirl.build(:submitted_file, filename: f, work: w) }
  end

private

  def common_submitted_files(n)
    res = []
    1.upto(n) do
     |x|
     file = get_file_to_submit
     res << yield(file.path, @work)
    end
    res
  end

end
