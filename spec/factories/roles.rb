FactoryGirl.define do

  factory :role do
    static      false
    description { Forgery(:basic).text(:at_least=>5, :at_most=>10) }

    #
    # Static roles already pre-defined
    #
    trait :music_composer do
      static      true
      description "Music Composer"
    end
    trait :text_author do
      static      true
      description "Text Author"
    end
    trait :video_author do
      static      true
      description "Video Author"
    end
    trait :video_director do
      static      true
      description "Video Director"
    end
    trait :video_producer do
      static      true
      description "Video Producer"
    end
    trait :performer do
      static      true
      description "Performer"
    end
    trait :conductor do
      static      true
      description "Conductor"
    end
    trait :electroacoustic_director do
      static      true
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
