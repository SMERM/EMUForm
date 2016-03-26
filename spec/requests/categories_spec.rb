require 'rails_helper'

RSpec.describe "Categories", type: :request do

  context 'not logged in' do

    describe "GET /categories" do
  
      it "won't go anywhere if you're not an admin" do
        get categories_path
        expect(response).to redirect_to(admin_account_session_path)
      end
  
    end

  end

  context 'logged in as normal user' do

    before :each do
      @account = FactoryGirl.create(:account)
      login_as @account, scope: :account
    end

    after :each do
      logout @account
    end

    describe "GET /categories" do

      it "won't go anywhere if you're not an admin" do
        get categories_path
        expect(response).to redirect_to(admin_account_session_path)
      end
  
    end

  end

  context 'logged in as admin user' do

    before :example do
      @category = FactoryGirl.create(:category)
      @account = FactoryGirl.create(:admin_account)
      login_as @account, scope: :admin_account
    end

    after :example do
      logout @account
      @category.destroy
    end

    describe 'GET /categories' do

      it 'works!' do
        get categories_path
        expect(response).to have_http_status(200)
      end

    end

    describe "POST /categories" do

      it "works! " do
        new_category = FactoryGirl.build(:category)
        post categories_path, { :category => new_category.attributes }
        c = Category.where('acro = ?', new_category[:acro]).first
        expect(response).to redirect_to(category_path(c))
      end

    end

    describe "GET /categories/new" do

      it "works! " do
        get new_category_path
        expect(response).to have_http_status(200)
        expect(response).to render_template('new')
      end

    end

    describe "GET /categories/:id/edit" do

      it "works! " do
        get edit_category_path(@category)
        expect(response).to have_http_status(200)
        expect(response).to render_template('edit')
      end

    end

    describe "GET /categories/:id" do
      it "works! " do
        get category_path(@category)
        expect(response).to have_http_status(200)
        expect(response).to render_template('show')
      end
    end

    describe "PATCH /categories/:id" do
      it "works! " do
        patch category_path(@category), { :category => @category.attributes }
        expect(response).to redirect_to(category_path(@category))
      end
    end

    describe "PUT /categories/:id" do
      it "works! " do
        put category_path(@category), { :category => @category.attributes }
        expect(response).to redirect_to(category_path(@category))
      end
    end

    describe "DELETE /categories/:id" do
      it "works! " do
        delete category_path(@category)
        expect(response).to redirect_to(categories_path)
      end
    end

  end

end
