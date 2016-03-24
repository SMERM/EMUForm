require 'rails_helper'
require_relative File.join('..', 'support', 'work_builder')

RSpec.describe "Works", type: :request do

  before :example do
    @work = FactoryGirl.create(:work_with_authors_and_roles)
  end

  context 'user not signed in' do

    describe "GET /works" do
      it "works! redirected to sign-up " do
        get works_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "POST /works" do
      it "works! redirected to sign-up " do
        post works_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /works/new" do
      it "works! redirected to sign-up " do
        get new_work_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /works/:id/edit" do
      it "works! redirected to sign-up " do
        get edit_work_path(@work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /works/:id" do
      it "works! redirected to sign-up " do
        get work_path(@work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PATCH /works/:id" do
      it "works! redirected to sign-up " do
        patch work_path(@work), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PUT /works/:id" do
      it "works! redirected to sign-up " do
        put work_path(@work), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "DELETE /works/:id" do
      it "works! redirected to sign-up " do
        delete work_path(@work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

  end

  context 'user signed in' do

    before :each do
      @account = FactoryGirl.create(:account)
      @account.works << @work
      sign_in @account
    end

    after :each do
      sign_out @account
    end

    describe "GET /works" do
      it "works! " do
        get works_path
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /works" do
      it "works! " do
        Work.destroy_all
        new_work = FactoryGirl.build(:work)
        post works_path, { :work => new_work.attributes }
        w = Work.where('title = ?', new_work.title).first
        expect(response).to redirect_to(select_work_authors_path(w))
      end
    end

    describe "GET /works/new" do
      it "works! " do
        get new_work_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /works/:id/edit" do
      it "works! " do
        get edit_work_path(@work)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /works/:id" do
      it "works! " do
        get work_path(@work)
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH /works/:id" do
      it "works! " do
        patch work_path(@work), { :work => @work.attributes }
        expect(response).to redirect_to(work_path(@work))
      end
    end

    describe "PUT /works/:id" do
      it "works! " do
        put work_path(@work), { :work => @work.attributes }
        expect(response).to redirect_to(work_path(@work))
      end
    end

    describe "DELETE /works/:id" do
      it "works! " do
        delete work_path(@work)
        expect(response).to redirect_to(works_path)
      end
    end

    describe 'GET /works/:id/attach_file' do

      it "works! " do
        get attach_file_work_path(@work)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /works/:id/upload_file' do

      include WorkBuilderSpecHelper

      before :example do
        @num_submitted_files = 2
        @submitted_files_attributes = build_submitted_files_attributes(@num_submitted_files)
      end
    
      it "works! " do
        #
        # TODO: solve this problem
        #
        skip("This cannot be tested as such because we can't find a way to send binary objects through the post request")
        post upload_file_work_path(@work), { work: { submitted_files_attributes: @submitted_files_attributes } }, { multipart: true }
        expect(response).to redirect_to(work_path(@work))
      end

    end

  end

end
