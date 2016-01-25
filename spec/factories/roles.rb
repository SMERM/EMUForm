FactoryGirl.define do
  factory :role do
    description { Forgery(:basic).text(:at_least=>5, :at_most=>10) }
  end

end
