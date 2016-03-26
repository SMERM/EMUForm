require 'rails_helper'

RSpec.describe "works/edit", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @work = assign(:work, FactoryGirl.create(:work))
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", work_path(@work), "post" do
      |el|

      assert_select el, 'select#work_category_id[name=?]', 'work[category_id]'
      assert_select el, "input#work_title[name=?]", "work[title]"

    end
  end
end
