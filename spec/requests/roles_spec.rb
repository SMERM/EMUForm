#
#                       roles GET        /roles(.:format)                             roles#index
#                             POST       /roles(.:format)                             roles#create
#                    new_role GET        /roles/new(.:format)                         roles#new
#                   edit_role GET        /roles/:id/edit(.:format)                    roles#edit
#                        role GET        /roles/:id(.:format)                         roles#show
#                             PATCH      /roles/:id(.:format)                         roles#update
#                             PUT        /roles/:id(.:format)                         roles#update
#                             DELETE     /roles/:id(.:format)                         roles#destroy
#
require 'rails_helper'

RSpec.describe "Roles", type: :request do

  before :example do
    @role = FactoryGirl.create(:role)
  end

  context 'user not signed in' do

    describe "GET /roles" do
      it "works! redirected to sign-up " do
        get roles_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "POST /roles" do
      it "works! redirected to sign-up " do
        post roles_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /roles/new" do
      it "works! redirected to sign-up " do
        get new_role_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /roles/:id/edit" do
      it "works! redirected to sign-up " do
        get edit_role_path(@role)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /roles/:id" do
      it "works! redirected to sign-up " do
        get role_path(@role)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PATCH /roles/:id" do
      it "works! redirected to sign-up " do
        patch role_path(@role), { :role => @role.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PUT /roles/:id" do
      it "works! redirected to sign-up " do
        put role_path(@role), { :role => @role.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "DELETE /roles/:id" do
      it "works! redirected to sign-up " do
        delete role_path(@role)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

  end

  context 'user signed in' do

    before :each do
      @account = FactoryGirl.create(:account)
      sign_in @account
    end

    after :each do
      sign_out @account
    end

    describe "GET /roles" do
      it "works! " do
        get roles_path
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /roles" do
      it "works! " do
        new_role = FactoryGirl.build(:role)
        post roles_path, { :role => new_role.attributes }
        r = Role.where('description = ?', new_role.description).first
        expect(response).to redirect_to(role_path(r))
      end
    end

    describe "GET /roles/new" do
      it "works! " do
        get new_role_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /roles/:id/edit" do
      it "works! " do
        get edit_role_path(@role)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /roles/:id" do
      it "works! " do
        get role_path(@role)
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH /roles/:id" do
      it "works! " do
        patch role_path(@role), { :role => @role.attributes }
        expect(response).to redirect_to(role_path(@role))
      end
    end

    describe "PUT /roles/:id" do
      it "works! " do
        put role_path(@role), { :role => @role.attributes }
        expect(response).to redirect_to(role_path(@role))
      end
    end

    describe "DELETE /roles/:id" do
      it "works! " do
        delete role_path(@role)
        expect(response).to redirect_to(roles_path)
      end
    end

  end

end
