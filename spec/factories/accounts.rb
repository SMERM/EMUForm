FactoryGirl.define do

  factory :account do

    login_name            { Forgery(:internet).user_name }
    first_name            { Forgery(:name).female_first_name }
    last_name             { Forgery(:name).last_name }
    about                 { Forgery(:lorem_ipsum).sentences(1..5) }
    location              { "%s %s, %s %s %s" % [Forgery(:address).street_address, Forgery(:address).street_suffix, Forgery(:address).city, Forgery(:address).state_abbrev, Forgery(:address).zip] }
    email                 { Forgery(:internet).email_address }
    password              { Forgery(:basic).password(:at_least => 8) }
    password_confirmation { password }

    remember_created_at   { Forgery(:date).date(:min_delta => -1000, :max_delta => 0) - 1000.days }

    sign_in_count         { Forgery(:basic).number(:at_least => 0, :at_most => 23) }
    current_sign_in_at    { Time.zone.now - Forgery(:basic).number(:at_least => 0, :at_most => 120) }
    last_sign_in_at       { current_sign_in_at - Forgery(:basic).number(:at_least => -30, :at_most => -2).days }
    current_sign_in_ip    { Forgery(:internet).ip_v4 }
    last_sign_in_ip       { Forgery(:internet).ip_v4 }

    confirmation_token    { Forgery(:basic).text(:at_least => 32, :at_most => 64) }
    confirmed_at          { remember_created_at + Forgery(:basic).number(:at_least => 3, :at_most => 180).minutes }
    confirmation_sent_at  { confirmed_at - 1.minute }

    authentication_token  { Forgery(:basic).text(:at_least => 64, :at_most => 64) }

  end

end
