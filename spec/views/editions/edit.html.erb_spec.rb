require 'rails_helper'

RSpec.describe "editions/edit", type: :view do

  before(:each) do
    Edition.where('current = ?', :false).destroy_all
    @edition = assign(:edition, FactoryGirl.create(:edition))
  end

  it "renders the edit edition form" do
    render

    assert_select "form[action=?][method=?]", edition_path(@edition), "post" do

      assert_select "input#edition_title[name=?]", "edition[title]"

      assert_select "textarea#edition_description_en[name=?]", "edition[description_en]"

      assert_select "textarea#edition_description_it[name=?]", "edition[description_it]"
    end
  end
end
