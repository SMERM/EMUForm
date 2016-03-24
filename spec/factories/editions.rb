FactoryGirl.define do

  factory :edition do
    year                { Forgery(:date).year(past: true, max_delta: 10) }
    title               { Forgery(:emuform).title }
    start_date          { Time.new(year) + Forgery(:basic).number(at_least: 250, at_most: 310).days }
    end_date            { start_date + Forgery(:basic).number(at_least: 4, at_most: 15).days }
    description_en      { Forgery(:lorem_ipsum).sentences(5) }
    description_it      { Forgery(:lorem_ipsum).sentences(5) }
    submission_deadline { start_date - 5.months }

    initialize_with { Edition.switch(attributes) }
  end

end
