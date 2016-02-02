require 'rails_helper'

RSpec.describe "works/show", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = FactoryGirl.create(:author_with_works_and_roles, num_works: 2)
    @work = @author.works.uniq.first
  end

  it "renders attributes in <p>" do
    render
  end
end
