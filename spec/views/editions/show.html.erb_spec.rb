require 'rails_helper'

include ERB::Util

RSpec.describe "editions/show", type: :view do
  before(:each) do
    Edition.where('current = ?', :false).destroy_all
    @edition = assign(:edition, FactoryGirl.create(:edition))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{Regexp.escape(html_escape(@edition.title))}/)
    expect(rendered).to match(/#{Regexp.escape(html_escape(@edition.description_en))}/)
    expect(rendered).to match(/#{Regexp.escape(html_escape(@edition.description_it))}/)
  end
end
