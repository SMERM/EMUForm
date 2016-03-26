require 'rails_helper'

RSpec.describe "categories/index", type: :view do

  before(:each) do
    @num_categories = 5
    @categories = FactoryGirl.create_list(:category, @num_categories)
  end

  it "renders a list of categories" do

    render

    @categories.each do
      |c|
      assert_select "tr>td", :text => c.acro.to_s, :count => 1
      assert_select "tr>td", :text => c.title_en.to_s, :minimum => 1
      assert_select "tr>td", :text => c.title_it.to_s, :minimum => 1
      assert_select "tr>td", :text => c.description_en.to_s, :minimum => 1
      assert_select "tr>td", :text => c.description_it.to_s, :minimum => 1
    end

  end
end
