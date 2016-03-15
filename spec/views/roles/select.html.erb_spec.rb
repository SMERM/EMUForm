require 'rails_helper'
require_relative File.join(['..'] * 2, 'support', 'random_roles')

RSpec.describe "roles/select", type: :view do

  include RandomRoles

  before(:each) do
    @num_authors = 5
    @account = FactoryGirl.create(:account)
    @work = assign(:work, FactoryGirl.create(:work, owner_id: @account.to_param))
    @authors = assign(:authors, FactoryGirl.create_list(:author, @num_authors, owner_id: @account.to_param))
    @roles = assign(:roles, Role.ordered_all)
  end

  it "select a list of roles" do
    render
    @authors.each { |a| assert_select '.author_name', text: a.full_name + ':', count: 1 }
    @roles.each { |r| assert_select '.role_check_box', :text => r.description, :count => @num_authors }
  end

end
