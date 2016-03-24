require 'rails_helper'

RSpec.describe "editions/new", type: :view do
  before(:each) do
    Edition.where('current = ?', :false).destroy_all
    @edition = assign(:edition, Edition.switch)
  end

  it "renders new edition form" do
    render

    assert_select "form[action=?][method=?]", editions_path, "post" do

      assert_select "input#edition_title[name=?]", "edition[title]"

      assert_select "textarea#edition_description_en[name=?]", "edition[description_en]"

      assert_select "textarea#edition_description_it[name=?]", "edition[description_it]"
    end
  end
end
