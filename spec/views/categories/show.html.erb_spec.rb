require 'rails_helper'

RSpec.describe "categories/show", type: :view do
  before(:each) do
    @category = assign(:category, Category.create!(
      :acro => "Acro",
      :title_en => "Title En",
      :title_it => "Title It",
      :description_en => "MyText",
      :description_it => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Acro/)
    expect(rendered).to match(/Title En/)
    expect(rendered).to match(/Title It/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
