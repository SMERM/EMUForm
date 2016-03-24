require "rails_helper"

RSpec.describe EditionsController, type: :routing do

  describe "routing" do

    it "routes to #index" do
      expect(:get => "/editions").to route_to("editions#index")
    end

    it "routes to #new" do
      expect(:get => "/editions/new").to route_to("editions#new")
    end

    it "routes to #show" do
      expect(:get => "/editions/1").to route_to("editions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/editions/1/edit").to route_to("editions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/editions").to route_to("editions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/editions/1").to route_to("editions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/editions/1").to route_to("editions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/editions/1").to route_to("editions#destroy", :id => "1")
    end

  end

end
