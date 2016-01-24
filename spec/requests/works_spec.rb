require 'rails_helper'

RSpec.describe "Works", type: :request do
  describe "GET /works" do
    it "works! (now write some real specs)" do
      author = FactoryGirl.create(:author)
      get author_works_path(author.to_param)
      expect(response).to have_http_status(200)
    end
  end
end
