require 'rails_helper'
require_relative File.join('..', 'support', 'submitted_files_helper')

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
    @num_authors = 15
    @num_selected_authors = 3
    @authors = FactoryGirl.create_list(:author, @num_authors, owner_id: @account.to_param)
    selected_authors_idxs = []
    @num_selected_authors.times { selected_authors_idxs << Forgery(:basic).unique_number(selected_authors_idxs, at_least: 0, at_most: @authors.size - 1) } 
    @selected_authors = selected_authors_idxs.map { |n| @authors[n] }
    @new_work = FactoryGirl.build(:work)
    @work_count = Work.count
    @num_attached_files = 3
  end

  given(:account_data) {
    [ @account.last_name, @account.first_name, @account.location, @account.created_at.to_s, @account.remember_created_at.to_s ]
  }

  include SubmittedFilesHelper

  scenario 'a (existing) user walks in and adds a new work' do
    begin
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
      select @new_work.category.full_title, :from => 'work_category_id'
      fill_in 'Title', :with => @new_work.title
      select @new_work.year.year.to_s, :from => 'work_year_1i'
      select ("%02d" % @new_work.duration.hour), :from => 'work_duration_4i'
      select ("%02d" % @new_work.duration.min), :from => 'work_duration_5i'
      select ("%02d" % @new_work.duration.sec), :from => 'work_duration_6i'
      fill_in 'Instruments', :with => @new_work.instruments
      fill_in 'work_program_notes_en', :with => @new_work.program_notes_en
      fill_in 'work_program_notes_it', :with => @new_work.program_notes_it
      click_button 'Select author(s)'
      #
      # selecting some (existing) authors
      #
      expect(Work.count).to eq(@work_count + 1)
      expect(page).to have_content 'Work was successfully created.'
      expect(page).to have_content "Please select one (or more) authors for #{@new_work.title}:"
      @selected_authors.each { |sa| expect(page).to have_content sa.full_name }
      @selected_authors.each { |sa| select(sa.full_name) }
      click_button 'Confirm selection'
      #
      # select roles for each chosen author
      #
      expect(page).to have_content 'Select Roles for the following authors:'
      @selected_authors.each { |sa| expect(page).to have_content sa.full_name }
      @selected_authors.each do
        |sa|
        num_roles = Forgery(:basic).number(at_least: 1, at_most: (Role.count/2.0).floor)
        role_idxs = []
        num_roles.times { role_idxs << Forgery(:basic).unique_number(role_idxs, at_least: 1, at_most: Role.count - 1) }
        roles = []
        role_idxs.each { |n| roles << Role.all[n] }
        within("div.role_selector#author_#{sa.to_param}") { roles.each { |r| check(r.description) } }
      end
      click_button 'Submit selection of roles'
      #
      # select add files to upload and actually upload them
      #
      expect(page).to have_content "Upload files for #{@new_work.title}"
      filenames = []
      1.upto(@num_attached_files) { |f| filenames << get_file_to_submit }
      filenames.each { |f| expect(File.exists?(f)).to be(true) }
      attach_file('work_Add files', filenames)
      click_button 'Upload files'
      #
      # get back to the full display of the submitted work
      #
      expect(page).to have_content "Title: #{@new_work.title}"
      #
      # goes back to the work index
      #
      click_link('Back')
      expect(page).to have_content('List of Works')
      expect(page).to have_content(@new_work.title)
      #
      # sign out
      #
      click_link('Sign out')
      expect(page).to have_content('Sign in')
      #
      # and we're done!
      #
    ensure
      #
      # filenames might be blank if the spec has failed previously
      #
      filenames.each { |f| File.unlink(f) } unless filenames.blank?
    end
  end

end
