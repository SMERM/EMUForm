FactoryGirl.define do

  factory :role do
    description { Forgery(:basic).text(:at_least=>5, :at_most=>10) }

    #
    # Static roles already pre-defined
    #
    trait :music_composer do
      description "Music Composer"
    end
    trait :text_author do
      description "Text Author"
    end
    trait :video_author do
      description "Video Author"
    end
    trait :video_director do
      description "Video Director"
    end
    trait :video_producer do
      description "Video Producer"
    end
    trait :performer do
      description "Performer"
    end
    trait :conductor do
      description "Conductor"
    end
    trait :electroacoustic_director do
      description "Electroacoustic Director"
    end

    factory :music_composer,                 traits: [ :music_composer ]
    factory :text_author,                    traits: [ :text_author ]
    factory :video_author,                   traits: [ :video_author ]
    factory :video_director,                 traits: [ :video_director ]
    factory :video_producer,                 traits: [ :video_producer ]
    factory :performer,                      traits: [ :performer ]
    factory :conductor,                      traits: [ :conductor ]
    factory :electroacustic_director,        traits: [ :electroacustic_director ]

  end

end
