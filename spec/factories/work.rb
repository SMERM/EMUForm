FactoryGirl.define do

  factory :work do

    title                do
      start = Forgery(:basic).number(:at_least => 0, :at_most => 10)
      Forgery(:lorem_ipsum).words(start..start+Forgery(:basic).number(:at_least => start + 1, :at_most => start + 3))
    end
    year                 { DateTime.civil_from_format(:local, Forgery(:basic).number(:at_least => 1950, :at_most => Time.zone.now.year)) }
    duration             { Time.zone.parse("00:%02d:%02d" % [ Forgery(:basic).number(:at_least => 0, :at_most => 23), Forgery(:basic).number(:at_least => 1, :at_most => 59)]) }
    instruments          'pno, fl, cl'
    program_notes_en     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }
    program_notes_it     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }

  end

end

