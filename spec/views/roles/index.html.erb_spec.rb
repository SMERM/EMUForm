require 'rails_helper'

RSpec.describe "roles/index", type: :view do
  before(:each) do
    @num_roles = 5
    @roles = assign(:roles, FactoryGirl.create_list(:role, @num_roles))
  end

  it "renders a list of roles" do
    render
    @roles.each { |r| assert_select "tr>td", :text => r.description, :count => 1 }
  end
end
