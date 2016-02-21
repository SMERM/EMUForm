require 'rails_helper'

RSpec.describe "authors/edit", type: :view do
  before(:each) do
    @work = FactoryGirl.create(:work_with_authors_and_roles, num_authors: 1)
    @author = assign(:author, @work.authors.uniq.last)
  end

  it "renders the edit author form" do
    render

    assert_select "form[action=?][method=?]", work_author_path(@work, @author), "post" do

      assert_select "input#author_first_name[name=?]", "author[first_name]"

      assert_select "input#author_last_name[name=?]", "author[last_name]"

      assert_select "input#author_birth_year[name=?]", "author[birth_year]"

      assert_select "textarea#author_bio_en[name=?]", "author[bio_en]"

      assert_select "textarea#author_bio_it[name=?]", "author[bio_it]"
    end
  end
end
