FactoryGirl.define do

  factory :author do

    first_name           { Forgery(:name).female_first_name }
    last_name            { Forgery(:name).last_name }
    birth_year           { Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15) }
    bio_en               { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)) }
    bio_it               { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)) }

    factory :author_with_works_and_roles do

      transient do
        num_works 3
        num_roles 3
      end

      after :create do
        |a, evaluator|
        works = FactoryGirl.create_list(:work, evaluator.num_works)
        roles = [Role.music_composer, Role.conductor, Role.text_author, Role.performer, Role.electroacoustic_director, Role.video_author, Role.video_director][0..evaluator.num_roles-1]
        works.each { |w| roles.each { |r| a.add_work_with_role(w, r) } }
      end

    end

  end

end


