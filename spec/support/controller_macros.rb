module ControllerMacros

  def login_account
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:account]
      account = FactoryGirl.create(:account)
      sign_in account
    end
  end

end
