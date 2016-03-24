FactoryGirl.define do

  factory :admin_account do

    email                  { Forgery(:internet).email_address }
    password               { Forgery(:basic).password(at_least: 8) }
    password_confirmation  { password }
    
  end

end
