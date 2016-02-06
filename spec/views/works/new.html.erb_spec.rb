require 'rails_helper'

RSpec.describe "works/new", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author))
    @work = @author.works.new
    @minimum_roles = Role.static_roles.size
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", author_works_path(@author), "post" do
      |el|
      assert_select el, 'input[type=checkbox]', { minimum: @minimum_roles }
    end
  end

end
