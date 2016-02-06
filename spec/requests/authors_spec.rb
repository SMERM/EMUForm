#
#                     authors GET        /authors(.:format)                           authors#index
#                             POST       /authors(.:format)                           authors#create
#                  new_author GET        /authors/new(.:format)                       authors#new
#                 edit_author GET        /authors/:id/edit(.:format)                  authors#edit
#                      author GET        /authors/:id(.:format)                       authors#show
#                             PATCH      /authors/:id(.:format)                       authors#update
#                             PUT        /authors/:id(.:format)                       authors#update
#                             DELETE     /authors/:id(.:format)                       authors#destroy
#
require 'rails_helper'

RSpec.describe "Authors", type: :request do

  before :example do
    @author = FactoryGirl.create(:author)
  end

  context 'user not signed in' do

    describe "GET /authors" do
      it "works! redirected to sign-up " do
        get authors_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "POST /authors" do
      it "works! redirected to sign-up " do
        post authors_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /authors/new" do
      it "works! redirected to sign-up " do
        get new_author_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /authors/:id/edit" do
      it "works! redirected to sign-up " do
        get edit_author_path(@author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /authors/:id" do
      it "works! redirected to sign-up " do
        get author_path(@author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PATCH /authors/:id" do
      it "works! redirected to sign-up " do
        patch author_path(@author), { :author => @author.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PUT /authors/:id" do
      it "works! redirected to sign-up " do
        put author_path(@author), { :author => @author.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "DELETE /authors/:id" do
      it "works! redirected to sign-up " do
        delete author_path(@author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

  end

  context 'user signed in' do

    before :each do
      @account = FactoryGirl.create(:account)
      @account.authors << @author
      sign_in @account
    end

    after :each do
      sign_out @account
    end

    describe "GET /authors" do
      it "works! " do
        get authors_path
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /authors" do
      it "works! " do
        new_author = FactoryGirl.build(:author, owner_id: @account.id)
        post authors_path, { :author => new_author.attributes }
        a = Author.where('last_name = ? and first_name = ? and owner_id = ?', new_author.last_name, new_author.first_name, new_author.owner_id).first
        expect(response).to redirect_to(author_path(a))
      end
    end

    describe "GET /authors/new" do
      it "works! " do
        get new_author_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /authors/:id/edit" do
      it "works! " do
        get edit_author_path(@author)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /authors/:id" do
      it "works! " do
        get author_path(@author)
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH /authors/:id" do
      it "works! " do
        patch author_path(@author), { :author => @author.attributes }
        expect(response).to redirect_to(author_path(@author))
      end
    end

    describe "PUT /authors/:id" do
      it "works! " do
        put author_path(@author), { :author => @author.attributes }
        expect(response).to redirect_to(author_path(@author))
      end
    end

    describe "DELETE /authors/:id" do
      it "works! " do
        delete author_path(@author)
        expect(response).to redirect_to(account_path(@account))
      end
    end

  end

end
