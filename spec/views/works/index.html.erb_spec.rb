require 'rails_helper'

RSpec.describe "works/index", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author))
    @works = assign(:work, FactoryGirl.create_list(:work, 3))
    @role = Role.music_composer
    @works.each { |w| @author.add_work_with_role(w, @role) }
  end

  it "renders a list of works" do
    render
  end
end
