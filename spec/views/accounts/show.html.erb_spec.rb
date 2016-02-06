require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before(:each) do
    @account = FactoryGirl.create(:account)
    @attributes = [:first_name, :last_name, :email, :location, :remember_created_at]
  end

  it "renders attributes in <p>" do
    render
    @attributes.each { |a| expect(rendered).to match(/#{@account.send(a)}/) }
  end

end
