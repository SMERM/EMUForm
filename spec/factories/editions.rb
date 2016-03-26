require_relative File.join('..', 'support', 'factory_girl_helper')

include FactoryGirlHelper

FactoryGirl.define do

  factory :edition do
    year                { check_unique(Edition, :year) { Forgery(:date).year(past: true, max_delta: 20, min_delta: 2) } }
    title               { check_unique(Edition, :title) { Forgery(:emuform).title } }
    start_date          { Time.new(year) + Forgery(:basic).number(at_least: 250, at_most: 310).days }
    end_date            { start_date + Forgery(:basic).number(at_least: 4, at_most: 15).days }
    description_en      { Forgery(:lorem_ipsum).sentences(5) }
    description_it      { Forgery(:lorem_ipsum).sentences(5) }
    submission_deadline { start_date - 5.months }

    initialize_with { Edition.switch(attributes) }

    factory :old_edition_without_switch do

      current            :false

      initialize_with { Edition.send(:new, attributes) }

    end
  end

end
