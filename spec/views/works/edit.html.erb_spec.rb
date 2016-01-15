require 'rails_helper'

RSpec.describe "works/edit", type: :view do
  before(:each) do
    params = {
      :title => 'Test', :year => DateTime.civil_from_format(:local, 2012), :duration => Time.parse('03:03:03'), :instruments => 'pno, fl, cl', :program_notes_en => 'Test notes',
      :program_notes_it => 'Note di Test'
    }
    @work = assign(:work, Work.create!(params))
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", work_path(@work), "post" do
    end
  end
end
