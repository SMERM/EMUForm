#
#                author_works GET        /authors/:author_id/works(.:format)          works#index
#                             POST       /authors/:author_id/works(.:format)          works#create
#             new_author_work GET        /authors/:author_id/works/new(.:format)      works#new
#            edit_author_work GET        /authors/:author_id/works/:id/edit(.:format) works#edit
#                 author_work GET        /authors/:author_id/works/:id(.:format)      works#show
#                             PATCH      /authors/:author_id/works/:id(.:format)      works#update
#                             PUT        /authors/:author_id/works/:id(.:format)      works#update
#                             DELETE     /authors/:author_id/works/:id(.:format)      works#destroy
#
require 'rails_helper'

RSpec.describe "Works", type: :request do

  before :example do
    @author = FactoryGirl.create(:author_with_works_and_roles, num_works: 1, num_roles: 1)
    @work = @author.works.uniq.first
  end

  context 'user not signed in' do

    describe "GET /authors/:id/works" do
      it "works! redirected to sign-up " do
        get author_works_path(@author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "POST /authors/:id/works" do
      it "works! redirected to sign-up " do
        new_work = FactoryGirl.build(:work)
        awr = AuthorWorkRole.new(:author_id => @author.to_param, :role_id => Role.music_composer.id) 
        wparms = new_work.attributes
        wparms.update( roles_attributes: [{ id: Role.music_composer.to_param }] )
        post author_works_path(@author), { work: wparms }
        a = Work.joins(:author_work_roles).where('works.title = ? and author_work_roles.author_id = ? and author_work_roles.work_id = ?', new_work.title, @author.id, new_work.id).uniq.first
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /authors/:id/works/new" do
      it "works! redirected to sign-up " do
        get new_author_work_path(@author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /authors/:id/works/:id/edit" do
      it "works! redirected to sign-up " do
        get edit_author_work_path(@author, @work), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /author/:id/works/:id" do
      it "works! redirected to sign-up " do
        get author_work_path(@author, @work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PATCH /author/:id/works/:id" do
      it "works! redirected to sign-up " do
        patch author_work_path(@author, @work), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PUT /author/:id/works/:id" do
      it "works! redirected to sign-up " do
        put author_work_path(@author, @work), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "DELETE /authors/:id/works/:id" do
      it "works! redirected to sign-up " do
        delete author_work_path(@author, @work)
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

    describe "GET /authors/:id/works" do
      it "works! " do
        get author_works_path(@author)
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /authors/:id/works" do
      it "works! " do
        new_work = FactoryGirl.build(:work)
        wparms = new_work.attributes
        wparms.update( roles_attributes: [{ id: Role.music_composer.to_param }] )
        post author_works_path(@author), { work: wparms }
        w = @author.works.where('title = ?', new_work.title).uniq.first
        expect(response).to redirect_to(author_work_path(@author, w))
      end
    end

    describe "GET /authors/:id/works/new" do
      it "works! " do
        get new_author_work_path(@author)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /authors/:id/works/:id/edit" do
      it "works! " do
        get edit_author_work_path(@author, @work)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /authors/:id/works/:id" do
      it "works! " do
        get author_work_path(@author, @work)
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH /authors/:id/works/:id" do
      it "works! " do
        patch author_work_path(@author, @work), { :work => @work.attributes }
        expect(response).to redirect_to(author_work_path(@author, @work))
      end
    end

    describe "PUT /authors/:id/works/:id" do
      it "works! " do
        put author_work_path(@author, @work), { :work => @work.attributes }
        expect(response).to redirect_to(author_work_path(@author, @work))
      end
    end

    describe "DELETE /authors/:id/works/:id" do
      it "works! " do
        delete author_work_path(@author, @work)
        expect(response).to redirect_to(author_path(@author))
      end
    end

  end

end
