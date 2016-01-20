FactoryGirl.define do

  factory :work do

    title                'Test'
    year                 { DateTime.civil_from_format(:local, Forgery(:basic).number(:at_least => 1950, :at_most => Time.zone.now.year)) }
    duration             { Time.zone.parse('00:04:33') }
    instruments          'pno, fl, cl'
    program_notes_en     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 50)) }
    program_notes_it     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 50)) }

    #
    # since FactoryGirl does not use the +initialize+ method to build, we have
    # to call <tt>create_directory(args)</tt> ourselves.
    #
    initialize_with      { new(attributes) }

  end

end

