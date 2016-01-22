require 'rails_helper'

RSpec.describe "works/edit", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author))
    @work = assign(:work, FactoryGirl.create(:work))
    @author.works << @work
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", author_work_path(@author, @work), "post" do
    end
  end
end
