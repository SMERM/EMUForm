require 'rails_helper'

RSpec.describe "Pages", type: :request do

  describe "GET /" do
    it "works! (we get to the landing page)" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /landing" do
    it "works! (we get to the landing page too)" do
      get pages_landing_path
      expect(response).to have_http_status(200)
    end
  end

end
