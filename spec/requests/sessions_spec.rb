require 'rails_helper'

RSpec.describe "Sessions" do

  it "signs account in and out" do
    account = FactoryGirl.create(:account)

    sign_in account
    get authenticated_root_path
    expect(controller.current_account).to eq(account)

    sign_out account
    get authenticated_root_path
    expect(controller.current_account).to be_nil
  end

end
