require 'rails_helper'

RSpec.describe "authors/show", type: :view do
  before(:each) do
    @author = FactoryGirl.create(:author_with_works_and_roles, num_works: 1)
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to match(/#{@author.last_name}/)
    expect(rendered).to match(/#{@author.first_name}/)
    expect(rendered).to match(/#{@author.display_birth_year}/)

    @author.works(true).uniq.each do
      |w|
      expect(rendered).to match(/#{w.title}/)
      expect(rendered).to match(/#{w.display_year}/)
      expect(rendered).to match(/#{w.display_duration}/)
      expect(rendered).to match(/#{w.roles(true).uniq.map { |r| r.description }.join(', ')}/)
    end
  end
end
