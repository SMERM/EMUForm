require 'rails_helper'

RSpec.describe "works/show", type: :view do

  after :example do
    Work.destroy_all
  end

  before(:each) do
    @author = FactoryGirl.create(:author_with_works_and_roles, num_works: 2)
    @work = @author.works.uniq.first
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to match(/#{@work.title}/)
    expect(rendered).to match(/#{@work.display_year}/)
    expect(rendered).to match(/#{@work.display_duration}/)
    expect(rendered).to match(/#{@work.roles(true).map { |r| r.description }.uniq.sort.join(', ')}/)
  end
end
