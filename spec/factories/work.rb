FactoryGirl.define do

  factory :work do

    association          :owner

    title                do
      start = Forgery(:basic).number(:at_least => 0, :at_most => 100)
      Forgery(:lorem_ipsum).words(start..start+Forgery(:basic).number(:at_least => start + 1, :at_most => start + 3))
    end
    year                 { DateTime.civil_from_format(:local, Forgery(:basic).number(:at_least => 1950, :at_most => Time.zone.now.year)) }
    duration             { Time.zone.parse("00:%02d:%02d" % [ Forgery(:basic).number(:at_least => 0, :at_most => 23), Forgery(:basic).number(:at_least => 1, :at_most => 59)]) }
    instruments          'pno, fl, cl'
    program_notes_en     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }
    program_notes_it     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }

    factory :work_with_authors_and_roles do

      transient do
        num_authors 3
        num_roles 3
      end

      after :create do
        |w, evaluator|
        authors = FactoryGirl.create_list(:author, evaluator.num_authors, owner_id: w.owner_id)
        authors.each do
          |author|
          role_start = Forgery(:basic).number(:at_least => 0, :at_most => Role.count - evaluator.num_roles - 1)
          roles = Role.all[role_start..role_start + evaluator.num_roles-1]
          w.add_author_with_roles(author, roles)
        end
      end

    end

  end

end

