require "rails_helper"

RSpec.describe WorksRolesAuthorsController, type: :routing do

  describe "routing" do

    it "routes to #create" do
      expect(:post => "/works/1/works_roles_authors").to route_to("works_roles_authors#create", { work_id: '1' })
    end

  end

end
