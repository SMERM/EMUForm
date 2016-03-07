require 'rails_helper'

RSpec.describe "works/index", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @works = assign(:works, FactoryGirl.create_list(:work_with_authors_and_roles, 3, owner_id: 9999))
  end

  it "renders a list of works" do
    render
  end
end
