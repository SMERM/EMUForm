require 'rails_helper'

RSpec.describe "Pages", type: :request do

  describe "GET /welcome" do
    it "works! (we get to the welcome page)" do
      get pages_welcome_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /landing" do
    it "works! (we get to the landing page)" do
      get pages_landing_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /terms" do
    it "works! (we get to the terms page)" do
      get pages_landing_path
      expect(response).to have_http_status(200)
    end
  end

end
