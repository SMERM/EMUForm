FactoryGirl.define do

  factory :work do

    association          :owner

    title                { Forgery(:emuform).title }
    year                 { DateTime.civil_from_format(:local, Forgery(:basic).number(:at_least => 1950, :at_most => Time.zone.now.year)) }
    duration             { Time.zone.parse("00:%02d:%02d" % [ Forgery(:basic).number(:at_least => 0, :at_most => 23), Forgery(:basic).number(:at_least => 1, :at_most => 59)]) }
    instruments          'pno, fl, cl'
    program_notes_en     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }
    program_notes_it     { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }
    edition_id           nil # this is set automatically
    category_id          { Edition.current.categories[Forgery(:basic).number(at_least: 0, at_most: Edition.current.categories(true).count - 1)].to_param }

    factory :work_with_authors_and_roles do

      transient do
        num_authors 3
        num_roles 3
      end

      authors_attributes do
        res = []
        authors = FactoryGirl.create_list(:author, num_authors, owner_id: self.owner_id)
        authors.each do
          |a|
          h = { id: a.to_param }
          r_ids = []
          1.upto(num_roles) { r_ids << Forgery(:basic).unique_number(r_ids, at_least: 1, at_most: Role.count) }
          rh = r_ids.map { |r_id| { id: r_id } }
          h.update(roles_attributes: rh)
          res << h
        end
        res
      end

    end

  end

end
