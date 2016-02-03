FactoryGirl.define do

  factory :author do

    first_name           { Forgery(:name).female_first_name }
    last_name            { Forgery(:name).last_name }
    birth_year           { Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15) }
    bio_en               { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)) }
    bio_it               { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)) }

    factory :author_with_works do

      transient do
        num_works      3
      end

      after :create do
        |a, evaluator|
        works = FactoryGirl.create_list(:work, evaluator.num_works)
        works.each do
          |work|
          role_start = Forgery(:basic).number(:at_least => 0, :at_most => (Role.count / 2).floor)
          role_num = Forgery(:basic).number(:at_least => 1, :at_most => Role.count - role_start - 1)
          roles = Role.all[role_start..role_start+role_num]
          roles do
            |role|
            AuthorWorkRole.create(author_id: a.to_param, work_id: work.to_param, role_id: role.to_param)
          end
        end
      end

    end

  end

end


