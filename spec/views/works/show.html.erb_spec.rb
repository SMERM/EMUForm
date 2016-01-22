require 'rails_helper'

RSpec.describe "works/show", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author))
    @work = assign(:work, FactoryGirl.create(:work))
    @author.works << @work
  end

  it "renders attributes in <p>" do
    render
  end
end
