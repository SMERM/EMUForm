require_relative File.join('..', 'support', 'factory_girl_helper')

include FactoryGirlHelper

FactoryGirl.define do

  factory :category do
    acro               { check_unique(Category, :acro) { Forgery(:basic).text(exactly: 4, allow_numeric: false).upcase } }
    title_en           { Forgery(:lorem_ipsum).sentence }
    title_it           { title_en }
    description_en     { Forgery(:lorem_ipsum).sentences(3) }
    description_it     { description_en }
  end

end
