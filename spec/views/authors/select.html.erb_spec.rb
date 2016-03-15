require 'rails_helper'

RSpec.describe "authors/select", type: :view do

  before(:each) do
    Work.delete_all
    Author.delete_all
    WorkRoleAuthor.delete_all
    @num_authors = 15
    @account = FactoryGirl.create(:account)
    @work = FactoryGirl.create(:work, owner_id: @account.to_param)
    #
    # This is the way the controller assigns authors
    #
    @all_authors = assign(:all_authors, FactoryGirl.create_list(:author, @num_authors, owner_id: @account.to_param))
    @author = Author.new
  end

  it "renders a list of authors in a multiple select box" do
    render

    @all_authors.each do
      |auth|
      assert_select 'select[name=?]', 'role[authors_attributes][][id]' do
        |el|
        assert_select el, 'option', :text => auth.full_name, :count => property_count(auth, :last_name)
        assert_select el, 'option[value=?]', auth.to_param, :count => property_count(auth, :id)
      end
    end

  end

  def property_count(a, p)
    Author.where("id = ? and #{p} = '#{a.send(p)}'", a.to_param).count
  end

end
