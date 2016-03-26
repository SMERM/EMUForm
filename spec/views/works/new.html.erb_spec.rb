require 'rails_helper'

RSpec.describe "works/new", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @work = Work.new
    @minimum_roles = Role.static_roles.size
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", works_path, "post" do
      |el|

      assert_select el, 'select#work_category_id[name=?]', 'work[category_id]'
      assert_select el, "input#work_title[name=?]", "work[title]"

    end
  end

end
