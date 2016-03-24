require 'rails_helper'

RSpec.describe "Editions", type: :request do

  describe "GET /editions" do

    it "won't go anywhere if you're not an admin" do
      get editions_path
      expect(response).to redirect_to(admin_account_session_path)
    end

  end

end
