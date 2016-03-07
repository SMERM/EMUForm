require 'rails_helper'

RSpec.describe "accounts/accounts/show", type: :view do
  before(:each) do
    @account = FactoryGirl.create(:account)
    @attributes = [:first_name, :last_name, :email, :location, :created_at]
  end

  it "renders attributes in <p>" do
    render
    @attributes.each do
      |a|
      r=Regexp.escape(@account.send(a).to_s)
      expect(rendered).to match(r)
    end
  end

end
