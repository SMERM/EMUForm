require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before(:each) do
    @account = FactoryGirl.create(:account)
    @attributes = [:login_name, :first_name, :last_name, :email, :about, :location, :remember_created_at]
  end

  it "renders attributes in <p>" do
    render
    @attributes.each { |a| expect(rendered).to match(/#{@account.send(a)}/) }
  end

end