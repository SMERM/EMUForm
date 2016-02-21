require 'rails_helper'

RSpec.describe "authors/show", type: :view do
  before(:each) do
    @work = FactoryGirl.create(:work_with_authors_and_roles, num_authors: 1)
    @author = @work.authors.uniq.last
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to match(/#{@author.last_name}/)
    expect(rendered).to match(/#{@author.first_name}/)
    expect(rendered).to match(/#{@author.display_birth_year}/)

  end
end
