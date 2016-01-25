require 'rails_helper'

RSpec.describe "accounts/new", type: :view do
  before(:each) do
    @account = FactoryGirl.create(:account)
    @attributes = { 'input' => [:login_name, :first_name, :last_name, :email, :location], 'textarea' => [:about] }
  end

  it "renders new account form" do
    skip('this spec is to be (almost completely) refactored! [TODO]')
    render

    assert_select "form[action=?][method=?]", accounts_path, "post" do

      @attributes.each do
        |k, v|
        v.each { |type| assert_select "#{type}#account_#{k.to_s}[#{k.to_s}=?]", "account[#{k.to_s}]" }
      end

    end
  end
end
