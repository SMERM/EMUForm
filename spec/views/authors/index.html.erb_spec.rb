require 'rails_helper'

RSpec.describe "authors/index", type: :view do
  before(:each) do
    @num_authors = 3
    @authors = assign(:authors, FactoryGirl.create_list(:author, @num_authors))
  end

  it "renders a list of authors" do
    render

    @authors.each do
      |auth|
      assert_select "tr>td", :text => auth.first_name, :count => property_count(auth, :first_name)
      assert_select "tr>td", :text => auth.last_name, :count => property_count(auth, :last_name)
      assert_select "tr>td", :text => auth.birth_year.to_s, :count => property_count(auth, :birth_year)
    end
  end

  def property_count(a, p)
    Author.where("#{p} = '#{a.send(p)}'").count
  end

end
