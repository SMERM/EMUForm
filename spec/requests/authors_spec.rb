require 'rails_helper'

RSpec.describe "Authors", type: :request do

  before :example do
    @work = FactoryGirl.create(:work, owner_id: 9999)
  end

  before :each do
    @author = FactoryGirl.create(:author, owner_id: 9999)
  end

  context 'user not signed in' do

    describe "GET /work/:id/authors" do
      it "works! redirected to sign-up " do
        get work_authors_path(@work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "POST /works/:id/authors" do
      it "works! redirected to sign-up " do
        new_author = FactoryGirl.build(:author)
        aparms = new_author.attributes
        post work_authors_path(@work), { author: aparms }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /works/:id/authors/new" do
      it "works! redirected to sign-up " do
        get new_work_author_path(@work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /works/:id/authors/:id/edit" do
      it "works! redirected to sign-up " do
        get edit_work_author_path(@work, @author), { :author => @author.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "GET /author/:id/works/:id" do
      it "works! redirected to sign-up " do
        get work_author_path(@work, @author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PATCH /author/:id/works/:id" do
      it "works! redirected to sign-up " do
        patch work_author_path(@work, @author), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "PUT /author/:id/works/:id" do
      it "works! redirected to sign-up " do
        put work_author_path(@work, @author), { :work => @work.attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe "DELETE /works/:id/authors/:id" do
      it "works! redirected to sign-up " do
        delete work_author_path(@work, @author)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    describe 'GET /wors/:id/authors/select' do
      it "works! redirected to sign-up " do
        get select_work_authors_path(@work)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

  end

  context 'user signed in' do

    before :example do
      @account = FactoryGirl.create(:account)
      @account.works << @work
      @account.authors << @author
      sign_in @account
    end

    after :each do
      sign_out @account
    end

    describe "GET /works/:id/authors" do
      it "works! " do
        get work_authors_path(@work)
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /works/:id/authors" do
      it "works! " do
        new_author = FactoryGirl.build(:author, owner_id: @account.to_param) # need some proper attributes to save
        r = Role.music_composer
        aparms = new_author.attributes
        aparms.update(roles_attributes: [ { id: r.to_param } ])
        expect {
          post work_authors_path(@work), { author: aparms }
        }.to change(Author, :count).by(+1)
        a = @work.authors(true).where('last_name = ? and first_name = ?', new_author.last_name, new_author.first_name).uniq.first
        expect(a.valid?).to be(true)
        expect(a.roles(true).for_work(@work.to_param).count).to eq(1)
        expect(a.roles.for_work(@work.to_param).first.id).to eq(r.id)
        expect(response).to redirect_to(work_author_path(@work, a))
      end
    end

    describe "GET /works/:id/authors/new" do
      it "works! " do
        new_author = @work.authors.build
        get new_work_author_path(@work, new_author)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /works/:id/authors/:id/edit" do
      it "works! " do
        expect(@author.valid?).to be(true)
        add_author_to_work_with_a_random_role
        expect(@work.authors(true).uniq.count).to eq(1)
        get edit_work_author_path(@work, @author)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /works/:id/authors/:id" do
      it "works! " do
        expect(@author.valid?).to be(true)
        add_author_to_work_with_a_random_role
        expect(@work.authors(true).uniq.count).to eq(1)
        get work_author_path(@work, @author)
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH /works/:id/authors/:id" do
      it "works! " do
        expect(@author.valid?).to be(true)
        add_author_to_work_with_a_random_role
        expect(@work.authors(true).uniq.count).to eq(1)
        patch work_author_path(@work, @author), { :author => @author.attributes }
        expect(response).to redirect_to(work_author_path(@work, @author))
      end
    end

    describe "PUT /works/:id/authors/:id" do
      it "works! " do
        expect(@author.valid?).to be(true)
        add_author_to_work_with_a_random_role
        expect(@work.authors(true).uniq.count).to eq(1)
        put work_author_path(@work, @author), { :author => @author.attributes }
        expect(response).to redirect_to(work_author_path(@work, @author))
      end
    end

    describe "DELETE /works/:id/authors/:id" do
      it "works! " do
        expect(@author.valid?).to be(true)
        add_author_to_work_with_a_random_role
        expect(@work.authors(true).uniq.count).to eq(1)
        expect {
          delete work_author_path(@work, @author)
        }.to change(Author, :count).by(-1)
        expect(response).to redirect_to(work_authors_path(@work))
      end
    end

    describe "GET /works/:id/authors/select" do
      it "works! " do
        get select_work_authors_path(@work)
        expect(response).to have_http_status(200)
      end
    end

  end

private

  def add_author_to_work_with_a_random_role
    ridxs = Role.all.map { |r| r.id }
    rnum = Forgery(:basic).number(at_least: 0, at_most: ridxs.size - 1)
    role = Role.find(ridxs[rnum])
    WorkRoleAuthor.create!(work_id: @work.to_param, author_id: @author.to_param, role_id: role.to_param)
  end

end
