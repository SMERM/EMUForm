require 'rails_helper'

RSpec.describe "editions/index", type: :view do

  before(:each) do
    Edition.where('current = ?', :false).destroy_all
    @num_editions = 3
    @editions = assign(:editions, FactoryGirl.create_list(:edition, @num_editions))
  end

  it "renders a list of editions" do
    render
    @editions.each { |e| assert_select "tr>td", :text => e.title, :count => 1 }
  end

end
