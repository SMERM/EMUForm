require 'rails_helper'

RSpec.describe "works/show", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @work = FactoryGirl.create(:work_with_authors_and_roles, num_authors: 2)
    @author = @work.authors.uniq.first
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to match(/#{@work.title}/)
    expect(rendered).to match(/#{@work.display_year}/)
    expect(rendered).to match(/#{@work.authors.where('authors.id = ?', @author.to_param).uniq.first.roles(true).map { |r| r.description }.uniq.sort.join(', ')}/)
  end
end
