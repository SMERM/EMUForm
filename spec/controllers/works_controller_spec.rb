require 'rails_helper'
require_relative File.join('..', 'support', 'work_builder')

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

RSpec.describe WorksController, type: :controller do

  after :each do
    Work.destroy_all
  end

  before :each do
    @num_authors = 3
    @num_attachments = 3
    @num_roles = 3
    @work = FactoryGirl.create(:work)
    @authors = FactoryGirl.create_list(:author, @num_authors, owner_id: 9999)
    @role = Role.music_composer
    @roles = [Role.music_composer, Role.text_author, Role.conductor]
    @submitted_files_attributes = build_submitted_files_attributes(@num_attachments)
  end

  # This should return the minimal set of attributes required to create a valid
  # Work. As you add validations to Work, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    HashWithIndifferentAccess.new(
      :title => Forgery(:emuform).title,
      :'year(1i)' => Forgery(:basic).number(:at_least => 1850, :at_most => Time.zone.now.year).to_s, :'year(2i)' => '1', :'year(3i)' => '1',
      :'duration(1i)' => '1', :'duration(2i)' => '1', :'duration(3i)' => '1',
      :'duration(4i)' => '0', :'duration(5i)' => '4', :'duration(6i)' => '33',
      :instruments => 'pno, fl, cl',
      :program_notes_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
      :program_notes_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
      :authors_attributes => build_authors_and_roles_attributes(@authors, @num_roles),
    )
  }
  
  let(:valid_submitted_files_attributes) {
    HashWithIndifferentAccess.new(submitted_files_attributes: @submitted_files_attributes)
  }
  
  let(:invalid_attributes) {
    #
    # invalid because :title is empty and :non_existing_key does not exist
    #
    {
      :title => '', :'year(1i)' => '2016', :'year(2i)' => '1', :'year(3i)' => '1',
      :'duration(1i)' => '1', :'duration(2i)' => '1', :'duration(3i)' => '1',
      :'duration(4i)' => '0', :'duration(5i)' => '4', :'duration(6i)' => '33',
      :instruments => 'pno, fl, cl', :program_notes_en => 'Test notes',
      :program_notes_it => 'Note di Test', :non_existing_key => 'This key does not exist',
    }
  }

  let(:attribute_display_keys) {
    {
      :title => :title, :year => :display_year, :duration => :display_duration, :instruments => :instruments,
      :program_notes_en => :program_notes_en, :program_notes_it => :program_notes_it, :roles => :display_roles
    }
  }

  context 'account not signed in (shouldn\'t go anywhere here)' do

    describe "GET #index" do
      it "assigns all works belonging to a given author as @works" do
        work = build_environment(5, 4)
        get :index, { :work_id => work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #show" do
      it "assigns the requested work as @work" do
        work = create_environment(1)
        get :show, { :id => work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #new" do
      it "assigns a new work as @work" do
        work = build_environment
        get :new, {:work => {}}
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested work as @work" do
        work = create_environment(1, 1)
        get :edit, { :id => work.to_param}
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "cannot create a new Work" do
          post :create, { :work => valid_attributes }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "cannot assign a newly created work as @work" do
          post :create, { :work => valid_attributes }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "will not redirect to the created work" do
          post :create, {:work => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved work as @work" do
          post :create, {:work => invalid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "re-renders the 'new' template" do
          post :create, {:work => invalid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
            :title => 'Updated ' + Forgery(:name).title,
            :'year(1i)' => Forgery(:basic).number(:at_least => 1850, :at_most => Time.zone.now.year).to_s, :'year(2i)' => '1', :'year(3i)' => '1',
            :'duration(1i)' => '1', :'duration(2i)' => '1', :'duration(3i)' => '1',
            :'duration(4i)' => '0', :'duration(5i)' => '4', :'duration(6i)' => '33',
            :instruments => 'pno, fl, cl',
            :program_notes_en => 'Updated ' + Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
            :program_notes_it => 'Aggiornamento: ' + Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
            :authors_attributes => build_authors_and_roles_attributes(@authors[0..@num_authors-2], @num_roles-1),
          }
        }
  
        it "cannot update the requested work" do
          work = create_environment
          put :update, {:id => work.to_param, :work => new_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "cannot assign the requested work as @work" do
          work = create_environment
          put :update, {:id => work.to_param, :work => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "cannot redirect to the work" do
          work = create_environment
          put :update, {:id => work.to_param, :work => valid_attributes}
          expect(response).to redirect_to(new_account_session_path)
        end
      end
  
      context "with invalid params" do
        it "assigns the work as @work" do
          work = create_environment
          put :update, {:id => work.to_param, :work => invalid_attributes }
          expect(response).to redirect_to(new_account_session_path)
        end
  
        it "re-renders the 'edit' template" do
          work = create_environment
          put :update, {:id => work.to_param, :work => invalid_attributes }
          expect(response).to redirect_to(new_account_session_path)
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested work" do
        work = create_environment
        delete :destroy, {:id => work.to_param }
        expect(response).to redirect_to(new_account_session_path)
      end
    end

  end

  context 'account signed in (should be able to do most things)' do

    login_account

    before :example do
      subject.current_account.authors.concat(@authors)
      subject.current_account.reload
    end

    describe 'it should have a current valid account' do
      it 'does, indeed' do
        expect(subject.current_account).to_not eq(nil)
      end
    end

    describe "GET #index" do
      it "assigns all authors belonging to a given work as @works" do
        n_works = 5
        1.upto(n_works) { create_environment(1, 3, subject.current_account.to_param) }
        works = subject.current_account.works(true).uniq
        get :index
        expect(assigns(:works)).to eq(works)
      end
    end
  
    describe "GET #show" do
      it "assigns the requested work as @work" do
        work = create_environment(2, 1, subject.current_account.to_param)
        get :show, { :id => work.to_param }
        expect(assigns(:work)).to eq(work)
      end
    end
  
    describe "GET #new" do
      it "assigns a new work as @work" do
        get :new
        expect(assigns(:work)).to be_a_new(Work)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested work as @work" do
        work = create_environment(1, 1, subject.current_account.to_param)
        get :edit, {:id => work.to_param}
        expect(assigns(:work)).to eq(work)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Work" do
          expect {
            post :create, {:work => valid_attributes }
          }.to change(Work, :count).by(1)
          work = Work.last
          expect(work.reload.valid?).to be(true)
          expect(work.directory.blank?).to be(false)
          expect(work.authors(true).uniq.count).to eq(valid_attributes[:authors_attributes].size)
          work.authors(true) { |a| expect(a.roles(true).for_work(work.to_param).uniq.count).to eq(@num_roles) }
        end
  
        it "assigns a newly created work as @work" do
          post :create, {:work => valid_attributes}
          expect(assigns(:work)).to be_a(Work)
          expect(assigns(:work)).to be_persisted
        end
  
        it "redirects to the created work" do
          post :create, {:work => valid_attributes}
          expect(response).to redirect_to(select_work_authors_path(assigns(:work)))
        end
      end
  
      context "with invalid params" do
        it "assigns a newly created but unsaved work as @work" do
          post :create, { :work => invalid_attributes }
          expect(assigns(:work)).to be_a_new(Work)
        end
  
        it "re-renders the 'new' template" do
          post :create, {:work => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
            :title => 'Updated ' + Forgery(:name).title,
            :'year(1i)' => Forgery(:basic).number(:at_least => 1850, :at_most => Time.zone.now.year).to_s, :'year(2i)' => '1', :'year(3i)' => '1',
            :'duration(1i)' => '1', :'duration(2i)' => '1', :'duration(3i)' => '1',
            :'duration(4i)' => '0', :'duration(5i)' => '4', :'duration(6i)' => '33',
            :instruments => 'pno, fl, cl',
            :program_notes_en => 'Updated ' + Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
            :program_notes_it => 'Aggiornamento: ' + Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
            :authors_attributes => build_authors_and_roles_attributes(@authors[1..@authors.size-1], @num_roles + 1), # removing the first author and adding a role
          }
        }
  
        it "updates the requested work" do
          na = 3
          nr = 2
          work = create_environment(na, nr, subject.current_account.to_param)
          expect(work.authors(true).uniq.count).to eq(na)
          work.authors(true).uniq.map { |a| expect(a.roles(true).uniq.count).to eq(nr) }
          put :update, {:id => work.to_param, :work => new_attributes}
          work.reload
          expect(work.valid?).to be(true)
          expect(work.authors(true).uniq.count).to eq(na + new_attributes[:authors_attributes].size)
          work.authors(true).uniq.map { |a| expect(a.roles(true).for_work(work.to_param).count).to be >= nr }
        end
  
        it "assigns the requested work as @work" do
          work = create_environment(3, 2, subject.current_account.to_param)
          put :update, {:id => work.to_param, :work => valid_attributes}
          expect(assigns(:work)).to eq(work)
        end
  
        it "redirects to the work" do
          work = create_environment(3, 2, subject.current_account.to_param)
          put :update, {:id => work.to_param, :work => valid_attributes}
          expect(response).to redirect_to(work_path(work))
        end
        #
        # TODO: update a record *removing* a role and check
        #
      end
  
      context "with invalid params" do
        it "assigns the work as @work" do
          work = create_environment(3, 2, subject.current_account.to_param)
          put :update, {:id => work.to_param, :work => invalid_attributes }
          expect(assigns(:work)).to eq(work)
        end
  
        it "re-renders the 'edit' template" do
          work = create_environment(3, 2, subject.current_account.to_param)
          put :update, {:id => work.to_param, :work => invalid_attributes }
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested work" do
        work = create_environment(3, 2, subject.current_account.to_param)
        expect {
          delete :destroy, {:id => work.to_param }
        }.to change(Work, :count).by(-1)
      end
  
      it "redirects to the author works list" do
        work = create_environment(3, 2, subject.current_account.to_param)
        delete :destroy, {:id => work.to_param }
        expect(response).to redirect_to(works_path)
      end
    end

    describe 'GET #attach_file' do
      it 'goes to the attach file form' do
        work = create_environment(3, 2, subject.current_account.to_param)
        get :attach_file, { :id => work.to_param }
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #upload_file' do

      it 'actually uploads the submitted files' do
        work = create_environment(3, 2, subject.current_account.to_param)
        post :upload_file, { id: work.to_param, work: valid_submitted_files_attributes }
        expect(work.submitted_files(true).count).to eq(@num_attachments)
        valid_submitted_files_attributes[:submitted_files_attributes].each do
          |sfa|
          expect((sf = work.submitted_files.where('filename = ?', sfa[:filename]).first).class).to be(SubmittedFile)
          expect(File.exists?(sf.attached_file_full_path)).to be(true)
          expect(File.size(sf.attached_file_full_path)).to eq(sf.size)
        end
      end

    end

  end

private

  #
  # +create_enviroment(n_authors = 1, n_roles = 3, a_id = 9999)+: create a Factory work along with authors and roles as required
  #
  # the default account id should be non-existing 
  #
  def create_environment(n_authors = 1, n_roles = 3, a_id = 9999)
    FactoryGirl.create(:work_with_authors_and_roles, num_authors: n_authors, num_roles: n_roles, owner_id: a_id)
  end

  #
  # +build_enviroment(n_authors = 1, n_roles = 3, a_id = 9999)+: just build a Factory work along with authors and roles as required
  #
  # the default account id should be non-existing 
  #
  def build_environment(n_authors = 1, n_roles = 3, a_id = 9999)
    FactoryGirl.build(:work_with_authors_and_roles, num_authors: n_authors, num_roles: n_roles, owner_id: a_id)
  end

  include WorkBuilderSpecHelper # contains: build_authors_and_roles_attributes and build_submitted_files_attributes

end
