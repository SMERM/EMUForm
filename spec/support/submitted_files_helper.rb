module SubmittedFilesHelper

  FIXTURES_PATH        = File.expand_path(File.join(['..'] * 2, 'fixtures'), __FILE__)
  AUDIO_TEMPLATES_PATH = File.join(FIXTURES_PATH, 'audio')
  DOC_TEMPLATES_PATH   = File.join(FIXTURES_PATH, 'doc')
  TMPDIR               = File.join(Rails.root, 'tmp', 'submitted_files_helper')

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

  class TestFile
    attr_reader :filename, :file_type, :path

    DEFAULT_TEST_FILENAME = 'test'

    def initialize(ft, fn = DEFAULT_TEST_FILENAME, p = TMPDIR)
      @file_type = ft
      @filename = File.basename(fn, self.file_type.suffix)
      @path = p
    end

    def basename
      self.filename + self.file_type.suffix
    end

    def filename_full_path
      File.join(self.path, self.basename)
    end

    def clobber
      FileUtils.rm(self.filename_full_path)
    end

    class << self

      ORIG_FILES =
      {
        wav: FileType.new('.wav', AUDIO_TEMPLATES_PATH, 'audio', 'audio/x-wav', 'Content-Disposition: form-data'),
        mp3: FileType.new('.mp3', AUDIO_TEMPLATES_PATH, 'audio', 'audio/mpeg', 'Content-Disposition: form-data'),
        pdf: FileType.new('.pdf', DOC_TEMPLATES_PATH, 'doc', 'application/pdf', 'Content-Disposition: form-data'),
      }

      def get_file_type_to_submit(key = nil)
        unless key
          idx = Forgery(:basic).number(at_least: 0, at_most: ORIG_FILES.keys.size - 1)
          key = ORIG_FILES.keys[idx]
        end
        ORIG_FILES[key]
      end

      def get_file_to_submit(fn = DEFAULT_TEST_FILENAME)
        sfx = nil
        sfx = file_suffix(fn) if fn
        ft = sfx ? ORIG_FILES[sfx.to_sym] : get_file_type_to_submit
        src = File.join(ft.path, DEFAULT_TEST_FILENAME + ft.suffix)
        dest_filename = fn != DEFAULT_TEST_FILENAME ? fn : Forgery(:emuform).title + ft.suffix
        dest = orig_filename_full_path(dest_filename)
        FileUtils.ln(src, dest, force: true)
        new(ft, dest_filename)
      end

      def orig_filename_full_path(fn)
        [TMPDIR, fn].join('/')
      end

    end

  end

  def get_file_to_submit(orig_file = TestFile::DEFAULT_TEST_FILENAME)
    TestFile.get_file_to_submit(orig_file)
  end

  def get_files_to_submit(n_files)
    res = []
    names = []
    suffixes = [ '.mp3', '.wav', '.pdf' ]
    1.upto(n_files) do
      while true
        name = Forgery(:emuform).title
        sfx = suffixes[Forgery(:basic).number(at_least: 0, at_most: suffixes.size-1)]
        path = name + sfx
        break unless names.include?(path)
      end
      names << path
      res << get_file_to_submit(path)
    end
    res
  end

  def get_an_http_request_to_submit
    orig_file = TestFile.get_file_to_submit
    FactoryGirl.build(:uploaded_file, original_filename: orig_file.filename, content_type: orig_file.file_type.content_type, headers: orig_file.file_type.headers)
  end

  def create_submitted_files(n, w)
    common_submitted_files(n, w) { |hr, w| FactoryGirl.create(:submitted_file, http_request: hr, work: w) }
  end

  def build_submitted_files(n, w)
    common_submitted_files(n, w) { |hr, w| FactoryGirl.build(:submitted_file, http_request: hr, work: w) }
  end

  #
  # <tt>clean_up(submitted_file)</tt>
  #
  # cleans up all testing created files.
  #
  # The argument is a factory-created submitted file
  #
  def clean_up(sf)
    file_path = TestFile.orig_filename_full_path(sf.filename)
    FileUtils.rm(file_path) if File.exists?(file_path)
    affp_dirname = File.dirname(sf.attached_file_full_path)
    FileUtils.rm_r(affp_dirname) if Dir.exists?(affp_dirname)
  end

  def file_suffix(filename)
    res = nil
    ridx = filename.rindex('.')
    res = filename[ridx+1..-1] if ridx
    res
  end

private

  def common_submitted_files(n, w)
    res = []
    1.upto(n) do
     |x|
     hr = get_an_http_request_to_submit
     res << yield(hr, w)
    end
    res
  end

end
