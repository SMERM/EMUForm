require 'rails_helper'

RSpec.describe "roles/index", type: :view do
  before(:each) do
    assign(:roles, [
      Role.create!(
        :description => "Description"
      ),
      Role.create!(
        :description => "Description"
      )
    ])
  end

  it "renders a list of roles" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
