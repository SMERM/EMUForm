require 'rails_helper'

RSpec.describe "works/edit", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author_with_works_and_roles))
    @work = @author.works.uniq.first
    @minimum_roles = Role.static_roles.size
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", author_work_path(@author, @work), "post" do
      |el|
      assert_select el, 'input[type=checkbox]', { minimum: @minimum_roles }
    end
  end
end
