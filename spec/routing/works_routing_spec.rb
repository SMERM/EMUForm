require "rails_helper"

RSpec.describe WorksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/authors/1/works").to route_to("works#index", :author_id => '1')
    end

    it "routes to #new" do
      expect(:get => "/authors/1/works/new").to route_to("works#new", :author_id => '1')
    end

    it "routes to #show" do
      expect(:get => "/authors/1/works/1").to route_to("works#show", :id => "1", :author_id => '1')
    end

    it "routes to #edit" do
      expect(:get => "/authors/1/works/1/edit").to route_to("works#edit", :id => "1", :author_id => '1')
    end

    it "routes to #create (new)" do
      expect(:post => "/authors/1/works").to route_to("works#create", :author_id => '1')
    end

    it "routes to #create (edit)" do
      expect(:post => "/authors/1/works").to route_to("works#create", :author_id => '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/authors/1/works/1").to route_to("works#update", :id => "1", :author_id => '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/authors/1/works/1").to route_to("works#update", :id => "1", :author_id => '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/authors/1/works/1").to route_to("works#destroy", :id => "1", :author_id => '1')
    end

  end
end
