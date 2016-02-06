require 'rails_helper'

RSpec.describe "roles/edit", type: :view do
  before(:each) do
    @role = assign(:role, Role.create!(
      :description => "MyString"
    ))
  end

  it "renders the edit role form" do
    render

    assert_select "form[action=?][method=?]", role_path(@role), "post" do

      assert_select "input#role_description[name=?]", "role[description]"
    end
  end
end
