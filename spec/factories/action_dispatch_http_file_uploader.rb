FactoryGirl.define do

  factory :uploaded_file, class: ActionDispatch::Http::UploadedFile do

    original_filename do
      of = Tempfile.new(['Forgery_Lorem_Ipsum', '.txt'])
      File.open(of, 'w') do
        |fh|
        n_repeat = Forgery(:basic).number(:at_least => 10, :at_most => 100)
        1.upto(n_repeat) do
          text = Forgery(:lorem_ipsum).paragraphs(50)
          fh.write(text)
        end
      end
      of.path
    end
    content_type    'ascii/txt'
    headers         '' # FIXME: Don't know what to put here
    tempfile do
      tf = Tempfile.new
      FileUtils.cp(original_filename, tf.path)
      tf
    end

    #
    # remember that we can only use the +build+ method here because this is
    # not an ActiveRecord model
    #
    initialize_with { new(:filename => original_filename, :type => content_type, :head => headers, :tempfile => tempfile) }

  end

end
