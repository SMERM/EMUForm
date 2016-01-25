require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    @accounts = FactoryGirl.create_list(:account, 2)
  end

  it "renders a list of accounts" do
    skip('this spec is to be refactored! (TODO)')
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
