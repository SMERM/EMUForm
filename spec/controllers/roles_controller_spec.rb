require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe RolesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Role. As you add validations to Role, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { :description => Forgery(:basic).text(:at_least => 5, :at_most => 10) }
  }

  let(:invalid_attributes) {
    { :description=>""}
  }

  context 'account not signed in (shouldn\'t go anywhere here)' do

    describe "GET #show" do
      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        get :show, {:id => role.to_param}
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #new" do
      it "assigns a new role as @role" do
        get :new, {}
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        get :edit, {:id => role.to_param}
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Role" do
          post :create, {:role => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "assigns a newly created role as @role" do
          post :create, {:role => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "redirects to the created role" do
          post :create, {:role => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
      end
  
      context "with invalid params" do
        it "assigns a newly created but unsaved role as @role" do
          post :create, {:role => invalid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "re-renders the 'new' template" do
          post :create, {:role => invalid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { :description => "updated valid description" }
        }
  
        it "updates the requested role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => new_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "assigns the requested role as @role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "redirects to the role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
      end
  
      context "with invalid params" do
        it "assigns the role as @role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => invalid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "re-renders the 'edit' template" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => invalid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested role" do
        role = Role.create! valid_attributes
        delete :destroy, {:id => role.to_param}
        expect(response).to redirect_to(new_account_session_path)
      end
  
      it "redirects to the roles list" do
        role = Role.create! valid_attributes
        delete :destroy, {:id => role.to_param}
        expect(response).to redirect_to(new_account_session_path)
      end
    end

  end

  context 'account signed in (should do everything regularly)' do

    login_account

    describe "GET #show" do
      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        get :show, {:id => role.to_param}
        expect(assigns(:role)).to eq(role)
      end
    end
  
    describe "GET #new" do
      it "assigns a new role as @role" do
        get :new, {}
        expect(assigns(:role)).to be_a_new(Role)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        get :edit, {:id => role.to_param}
        expect(assigns(:role)).to eq(role)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Role" do
          expect {
            post :create, {:role => valid_attributes}
          }.to change(Role, :count).by(1)
        end
  
        it "assigns a newly created role as @role" do
          post :create, {:role => valid_attributes}
          expect(assigns(:role)).to be_a(Role)
          expect(assigns(:role)).to be_persisted
        end
  
        it "redirects to the created role" do
          post :create, {:role => valid_attributes}
          expect(response).to redirect_to(Role.last)
        end
      end
  
      context "with invalid params" do
        it "assigns a newly created but unsaved role as @role" do
          post :create, {:role => invalid_attributes}
          expect(assigns(:role)).to be_a_new(Role)
        end
  
        it "re-renders the 'new' template" do
          post :create, {:role => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { :description => "updated valid description" }
        }
  
        it "updates the requested role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => new_attributes}
          role.reload
          expect(role.description.blank?).to be(false)
          expect(Role.where("description = ?", role.description).count).to eq(1)
        end
  
        it "assigns the requested role as @role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => valid_attributes}
          expect(assigns(:role)).to eq(role)
        end
  
        it "redirects to the role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => valid_attributes}
          expect(response).to redirect_to(role)
        end
      end
  
      context "with invalid params" do
        it "assigns the role as @role" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => invalid_attributes}
          expect(assigns(:role)).to eq(role)
        end
  
        it "re-renders the 'edit' template" do
          role = Role.create! valid_attributes
          put :update, {:id => role.to_param, :role => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested role" do
        role = Role.create! valid_attributes
        expect {
          delete :destroy, {:id => role.to_param}
        }.to change(Role, :count).by(-1)
      end
  
      it "redirects to the roles list" do
        role = Role.create! valid_attributes
        delete :destroy, {:id => role.to_param}
        expect(response).to redirect_to(roles_url)
      end
    end

  end

end
