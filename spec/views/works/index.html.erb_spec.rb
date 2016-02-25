require 'rails_helper'

RSpec.describe "works/index", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = assign(:author, FactoryGirl.create(:author, owner_id: 9999))
    @works = assign(:work, FactoryGirl.create_list(:work, 3, owner_id: 9999))
    @role = Role.music_composer
    @works.each { |w| w.add_author_with_roles(@author, @role) }
  end

  it "renders a list of works" do
    render
  end
end
