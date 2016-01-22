require 'rails_helper'

RSpec.describe "works/new", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author))
    @work = assign(:work, @author.works.new)
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", author_works_path(@author), "post" do
    end
  end
end
