require "rails_helper"

RSpec.describe WorksRolesAuthorsController, type: :routing do

  describe "routing" do

    it "routes to #create" do
      expect(:post => "/works/1/works_roles_authors").to route_to("works_roles_authors#create", { work_id: '1' })
    end

    it "routes to #set_role" do
      expect(:post => "/works/1/works_roles_authors/2/set_role/3").to route_to("works_roles_authors#set_role", { work_id: '1', author_id: '2', id: '3' })
    end

    it "routes to #remove_author" do
      expect(:delete => "/works/1/works_roles_authors/remove_author/2").to route_to("works_roles_authors#remove_author", { work_id: '1', id: '2' })
    end

    it "routes to #remove_role" do
      expect(:delete => "/works/1/works_roles_authors/2/remove_role/3").to route_to("works_roles_authors#remove_role", { work_id: '1', author_id: '2', id: '3' })
    end

  end

end
