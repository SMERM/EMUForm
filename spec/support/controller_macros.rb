module ControllerMacros

  def login_account
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:account]
      account = FactoryGirl.create(:account)
      sign_in account
    end
  end

  def login_admin_account
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_account]
      admin_account = FactoryGirl.create(:admin_account)
      sign_in admin_account
    end
  end

end
