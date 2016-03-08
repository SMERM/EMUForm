require 'rails_helper'

describe "the signup process", :type => :feature do

  before :each do
    @new_account = FactoryGirl.build(:account)
  end

  it 'signs me up (with new credentials)' do
    visit root_path
    click_link 'Sign up'
    within('.sign_up') do
      fill_in 'Last name', :with => @new_account.last_name
      fill_in 'First name', :with => @new_account.first_name
      fill_in 'Email', :with => @new_account.email
      fill_in 'Location', :with => @new_account.location
      fill_in 'Password', :with => @new_account.password
      fill_in 'Password confirmation', :with => @new_account.password
    end
    click_button 'Sign up'
    expect(page).to have_content @new_account.last_name
  end

  #
  # TODO
  #
  # * failed signup
  # * signup with already existing credentials
  #

end

describe "the signin process", :type => :feature do

  before :each do
    @account = FactoryGirl.create(:account)
  end

  it "signs me in (with proper credentials)" do
    visit root_path
    within('.sign_in') do
      fill_in 'Email', :with => @account.email
      fill_in 'Email', :with => @account.email
      fill_in 'Password', :with => @account.password
    end
    click_button 'Log in'
    expect(page).to have_content @account.last_name
  end

  #
  # TODO
  #
  # * failed signin
  #

end
