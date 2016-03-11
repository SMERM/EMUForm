require 'rails_helper'

feature "a simple linear user journey " do

  #
  # <tt>A simple linear user journey</tt>
  #
  # * An (already existing) user logs in
  # * from login page clicks on the 'list of works'
  # * from the works index page clicks on the 'New Work' link
  # * adds a new work filling in all details
  # * selects an existing author
  # * selects some existing roles
  # * adds some submitted files
  # * goes back to the index page
  # * checks that the index lists his newly added work
  # * logs out
  #

  background :example do
    @account = FactoryGirl.create(:account)
    @num_authors = 5
    @authors = FactoryGirl.create_list(:author, @num_authors, owner_id: @account.to_param)
    @new_work = FactoryGirl.build(:work)
  end

  given(:account_data) {
    [ @account.last_name, @account.first_name, @account.location, @account.created_at.to_s, @account.remember_created_at.to_s ]
  }

  scenario 'a (existing) user walks in and adds a new work' do
    #
    # entrance
    #
    visit root_path
    fill_in 'Email', :with => @account.email
    fill_in 'Password', :with => @account.password
    check 'Remember me'
    click_button 'Log in'
    account_data.each { |d| expect(page).to have_content d }
    #
    # going to the list of works
    #
    click_link 'List of Works'
    expect(page).to have_content 'List of Works'
    expect(page).to have_link    'New Work'
    #
    # adding a new work
    #
    click_link 'New Work'
    expect(page).to have_content 'Submit New Work'
    expect(page).to have_button  'Select author(s)'
    fill_in 'Title', :with => @new_work.title
    select @new_work.year.year.to_s, :from => 'work_year_1i'
    select ("%02d" % @new_work.duration.hour), :from => 'work_duration_4i'
    select ("%02d" % @new_work.duration.min), :from => 'work_duration_5i'
    select ("%02d" % @new_work.duration.sec), :from => 'work_duration_6i'
    fill_in 'Instruments', :with => @new_work.instruments
    fill_in 'work_program_notes_en', :with => @new_work.program_notes_en
    fill_in 'work_program_notes_it', :with => @new_work.program_notes_it
    #
    # selecting an (existing author)
    #
    click_button 'Select author(s)'
    #
    # TO BE COMPLETED
    #
  end

end
