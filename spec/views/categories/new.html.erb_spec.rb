require 'rails_helper'

RSpec.describe "categories/new", type: :view do
  before(:each) do
    assign(:category, Category.new(
      :acro => "MyString",
      :title_en => "MyString",
      :title_it => "MyString",
      :description_en => "MyText",
      :description_it => "MyText"
    ))
  end

  it "renders new category form" do
    render

    assert_select "form[action=?][method=?]", categories_path, "post" do

      assert_select "input#category_acro[name=?]", "category[acro]"

      assert_select "input#category_title_en[name=?]", "category[title_en]"

      assert_select "input#category_title_it[name=?]", "category[title_it]"

      assert_select "textarea#category_description_en[name=?]", "category[description_en]"

      assert_select "textarea#category_description_it[name=?]", "category[description_it]"
    end
  end
end
