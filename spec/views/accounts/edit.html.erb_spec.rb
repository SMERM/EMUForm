require 'rails_helper'

RSpec.describe "accounts/edit", type: :view do
  before(:each) do
    @account = FactoryGirl.create(:account)
  end

  it "renders the edit account form" do
    skip('this spec is to be refactored! [TODO]')
    render

    assert_select "form[action=?][method=?]", account_path(@account), "post" do

      assert_select "input#account_name[name=?]", "account[name]"

      assert_select "textarea#account_about[name=?]", "account[about]"
    end
  end
end
