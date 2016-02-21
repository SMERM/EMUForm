require "rails_helper"

RSpec.describe AuthorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/works/1/authors").to route_to("authors#index", :work_id => '1')
    end

    it "routes to #new" do
      expect(:get => "/works/1/authors/new").to route_to("authors#new", :work_id => '1')
    end

    it "routes to #show" do
      expect(:get => "/works/1/authors/1").to route_to("authors#show", :id => "1", :work_id => '1')
    end

    it "routes to #edit" do
      expect(:get => "/works/1/authors/1/edit").to route_to("authors#edit", :id => "1", :work_id => '1')
    end

    it "routes to #create" do
      expect(:post => "/works/1/authors").to route_to("authors#create", :work_id => '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/works/1/authors/1").to route_to("authors#update", :id => "1", :work_id => '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/works/1/authors/1").to route_to("authors#update", :id => "1", :work_id => '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/works/1/authors/1").to route_to("authors#destroy", :id => "1", :work_id => '1')
    end

  end
end
