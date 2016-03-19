require 'rails_helper'

RSpec.describe "works/attach_file", type: :view do

  before :example do
    @work = FactoryGirl.create(:work)
  end

  it "renders the attach file form" do
    render

    assert_select "form[action=?][method=?]", upload_file_work_path(@work), "post" do
      |el|

      assert_select el, "input#file_field[name=?]", "work[submitted_files_attributes][][filename]"

    end
  end

end
