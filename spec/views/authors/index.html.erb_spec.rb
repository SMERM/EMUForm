require 'rails_helper'

RSpec.describe "authors/index", type: :view do
  before(:each) do
    Work.delete_all
    Author.delete_all
    WorkRoleAuthor.delete_all
    @num_authors = 3
    @work = FactoryGirl.create(:work_with_authors_and_roles, num_authors: @num_authors)
    @authors = assign(:authors, @work.authors(true).uniq)
  end

  it "renders a list of authors" do
    render

    @authors.each do
      |auth|
      assert_select "tr>td", :text => auth.full_name, :count => property_count(auth, :last_name)
      assert_select "tr>td", :text => auth.display_birth_year, :count => property_count(auth, :birth_year)
    end
  end

  def property_count(a, p)
    Author.where("id = ? and #{p} = '#{a.send(p)}'", a.to_param).count
  end

end
