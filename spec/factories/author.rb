FactoryGirl.define do

  factory :author do

    first_name           { Forgery(:name).female_first_name }
    last_name            { Forgery(:name).last_name }
    birth_year           { Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15) }
    bio_en               { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }
    bio_it               { Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)) }
    owner_id             nil

    transient do
      works_attributes     []
    end

    after :create do
      |a, evaluator|
      evaluator.works_attributes.each do
        |wa|
        w = Work.find(wa[:id])
        roles = FactoryGirl.create_list(:role, 2)
        w.add_author_with_roles(a, roles)
      end
    end

  end

end
