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

RSpec.describe AuthorsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Author. As you add validations to Author, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
	    :first_name => Forgery(:name).female_first_name, :last_name => Forgery(:name).last_name,
	    :birth_year => Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15),
	    :bio_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
	    :bio_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
      :owner_id => 9999, # fake owner which (supposedly) does not exist
    }
  }

  let(:invalid_attributes) {
    {
	    :first_name => '', :last_name => '',
	    :birth_year => Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15),
	    :bio_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
	    :bio_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
    }
  }

  after :example do
    Author.destroy_all
  end

  before :example do
    @num_authors = 3
    @work = FactoryGirl.create(:work)
  end

  context 'without logging in (there\'s little that we can do)' do

    describe "GET #index" do
      it "does not assign all authors as @authors" do
        get :index, { :work_id => @work.to_param } 
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #show" do
      it "does not assign the requested author as @author" do
        author = create_author
        get :show, {id: author.to_param, work_id: @work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #new" do
      it "does not assign a new author as @author" do
        get :new, { work_id: @work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #edit" do
      it "does not assign the requested author as @author" do
        author = create_author
        get :edit, {id: author.to_param, work_id: @work.to_param}
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #select" do
      it "does not assign all the authors as @authors" do
        get :select, { work_id: @work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "cannot create a new Author" do
          post :create, {author: valid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "cannot assign a newly created author as @author" do
          post :create, {author: valid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "does not redirect to the created author" do
          post :create, {author: valid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
      end
  
      context "with invalid params" do
        it "does not assign a newly created but unsaved author as @author" do
          post :create, {author: invalid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "does not re-render the 'new' template" do
          post :create, {author: invalid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
            :first_name => Forgery(:name).female_first_name, :last_name => Forgery(:name).last_name,
            :birth_year => Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15),
            :bio_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
            :bio_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
          }
        }
  
        it "does not update the requested author" do
          author = create_author
          put :update, { id: author.to_param, author: new_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "does not assign the requested author as @author" do
          author = create_author
          put :update, {:id => author.to_param, :author => new_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "does not redirect to the author" do
          author = create_author
          put :update, {:id => author.to_param, :author => new_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
      end
  
      context "with invalid params" do
        it "does not assign the author as @author" do
          author = create_author
          put :update, {:id => author.to_param, :author => invalid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "does not re-render the 'edit' template" do
          author = create_author
          put :update, {:id => author.to_param, :author => invalid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_account_session_path)
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "does not destroy the requested author" do
        author = create_author
        delete :destroy, {:id => author.to_param, work_id: @work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
  
      it "does not redirect to the authors list" do
        author = create_author
        delete :destroy, {:id => author.to_param, work_id: @work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
  
    end

  end

  context 'logging in we can indeed do much more' do

    login_account

    before :example do
      subject.current_account.works << @work
      subject.current_account.reload
    end

    describe "GET #index" do
      it "assigns all authors as @authors" do
        authors = @work.authors.uniq
        get :index, { work_id: @work.to_param }
        expect(assigns(:authors)).to eq(authors)
      end
    end
  
    describe "GET #show" do
      it "assigns the requested author as @author" do
        author = create_author(subject.current_account.to_param)
        get :show, {:id => author.to_param, work_id: @work.to_param }
        expect(assigns(:author)).to eq(author)
      end
    end
  
    describe "GET #new" do
      it "assigns a new author as @author" do
        get :new, { work_id: @work.to_param }
        expect(assigns(:author)).to be_a_new(Author)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested author as @author" do
        author = create_author(subject.current_account.to_param)
        get :edit, {:id => author.to_param, work_id: @work.to_param }
        expect(assigns(:author)).to eq(author)
      end
    end
  
    describe "GET #select" do
      it "does assign all the authors as @authors" do
        authors = []
        1.upto(@num_authors) { authors << create_author }
        authors = Author.all.order('last_name, first_name').uniq
        get :select, { work_id: @work.to_param }
        expect(response).to have_http_status(200)
        expect(response).to render_template('select')
        expect(assigns(:authors)).to eq(authors)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Author" do
          expect {
            post :create, {:author => valid_attributes, work_id: @work.to_param }
          }.to change(Author, :count).by(1)
        end
  
        it "assigns a newly created author as @author" do
          post :create, {:author => valid_attributes, work_id: @work.to_param }
          expect(assigns(:author)).to be_a(Author)
          expect(assigns(:author)).to be_persisted
        end
  
        it "redirects to the created author" do
          post :create, {:author => valid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(work_author_path(@work, Author.last))
        end
      end
  
      context "with invalid params" do
        it "assigns a newly created but unsaved author as @author" do
          post :create, {:author => invalid_attributes, work_id: @work.to_param }
          expect(assigns(:author)).to be_a_new(Author)
        end
  
        it "re-renders the 'new' template" do
          post :create, {:author => invalid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(new_work_author_path(@work))
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
            :first_name => Forgery(:name).female_first_name, :last_name => Forgery(:name).last_name,
            :birth_year => Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15),
            :bio_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
            :bio_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
          }
        }
  
        it "updates the requested author" do
          author = create_author(subject.current_account.to_param)
          put :update, {:id => author.to_param, :author => new_attributes, work_id: @work.to_param }
          author.reload
          new_attributes.keys.each { |na| expect(author.send(na)).to eq(new_attributes[na]) }
        end
  
        it "assigns the requested author as @author" do
          author = create_author(subject.current_account.to_param)
          put :update, {:id => author.to_param, :author => valid_attributes, work_id: @work.to_param }
          expect(assigns(:author)).to eq(author)
        end
  
        it "redirects to the author" do
          author = create_author(subject.current_account.to_param)
          put :update, {:id => author.to_param, :author => valid_attributes, work_id: @work.to_param }
          expect(response).to redirect_to(work_author_path(@work, author))
        end
      end
  
      context "with invalid params" do
        it "assigns the author as @author" do
          author = create_author(subject.current_account.to_param)
          put :update, {:id => author.to_param, :author => invalid_attributes, work_id: @work.to_param }
          expect(assigns(:author)).to eq(author)
        end
  
        it "re-renders the 'edit' template" do
          author = create_author(subject.current_account.to_param)
          put :update, {:id => author.to_param, :author => invalid_attributes, work_id: @work.to_param }
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested author" do
        author = create_author(subject.current_account.to_param)
        expect {
          delete :destroy, {:id => author.to_param, work_id: @work.to_param }
        }.to change(Author, :count).by(-1)
      end
  
      it "redirects to the account list of authors" do
        author = create_author(subject.current_account.to_param)
        delete :destroy, {:id => author.to_param, work_id: @work.to_param }
        expect(response).to redirect_to(account_path)
      end
    end

  end

private

  def create_author(owner_id = 9999, work = @work)
    args = valid_attributes.update(owner_id: owner_id)
    a = FactoryGirl.create(:author, args)
    r = Role.music_composer
    WorkRoleAuthor.create(work_id: work.to_param, author_id: a.to_param, role_id: r.to_param)
    a
  end

end
