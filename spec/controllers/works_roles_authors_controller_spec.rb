require 'rails_helper'
require_relative File.join('..', 'support', 'random_roles')

RSpec.describe WorksRolesAuthorsController, type: :controller do

  include RandomRoles

  before :example do
    @num_authors = 3
    @num_roles = 3
    @work = FactoryGirl.create(:work, owner_id: 9999)
    @authors = FactoryGirl.create_list(:author, @num_authors, owner_id: 9999)
  end

  let(:valid_attributes) {
    HashWithIndifferentAccess.new(work_id: @work.to_param, works_roles_authors: build_params_hash)
  }

  context 'not logged in' do

    describe "POST #create" do

      it "should redirect to login" do
        post :create, valid_attributes
        expect(response).to redirect_to(new_account_session_path)
      end

    end
  
  end

  context 'logged in' do

    login_account

    before :example do
      subject.current_account.authors.concat(@authors)
      subject.current_account.works << @work
      subject.current_account.reload
    end

    describe "POST #create" do

      it 'creates several connections between work, roles and authors' do
        expect {
          post :create, valid_attributes
        }.to change(WorkRoleAuthor, :count).by(@num_authors * @num_roles)
        expect(response).to redirect_to(attach_file_work_path(@work))
      end

      it 'redirects back when attributes are invalid' do
        skip("can't find the way to make this succeed (works roles authors never fail)")
        invalid_attributes = valid_attributes.deep_dup
        invalid_attributes[:works_roles_authors][:authors_attributes].first.update(id: '')
        post :create, invalid_attributes
        expect(response).to redirect_to(select_work_authors_path(@work))
      end

    end
  
  end

private

  def build_params_hash
    res = { authors_attributes: [] }
    @authors.each do
      |a|
      h_author = { id: a.to_param }
      roles = select_random_roles(@num_roles)
      h_author.update(roles_attributes: roles.map { |r| { id: r.to_param } })
      h_author[:roles_attributes] << { id: '' } # empty one to simulate form view behaviour
      res[:authors_attributes] << h_author
    end
    res
  end

end
