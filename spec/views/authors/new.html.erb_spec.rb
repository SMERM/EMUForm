require 'rails_helper'

RSpec.describe "authors/new", type: :view do
  before(:each) do
    @work = FactoryGirl.create(:work)
    @author = assign(:author, @work.authors.new)
  end

  it "renders new author form" do
    render

    assert_select "form[action=?][method=?]", work_authors_path(@work), "post" do
      |el|

      assert_select el, "input#author_first_name[name=?]", "author[first_name]"

      assert_select el, "input#author_last_name[name=?]", "author[last_name]"

      assert_select el, "input#author_birth_year[name=?]", "author[birth_year]"

      assert_select el, "textarea#author_bio_en[name=?]", "author[bio_en]"

      assert_select el, "textarea#author_bio_it[name=?]", "author[bio_it]"

      assert_select el, 'input[type=checkbox]', { minimum: @minimum_roles }
    end
  end
end
