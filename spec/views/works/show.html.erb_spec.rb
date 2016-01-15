require 'rails_helper'

RSpec.describe "works/show", type: :view do
  before(:each) do
    params = {
      :title => 'Test', :year => '2012-01-01', :duration => '03:03:03', :instruments => 'pno, fl, cl', :program_notes_en => 'Test notes',
      :program_notes_it => 'Note di Test'
    }
    @work = assign(:work, Work.create!(params))
  end

  it "renders attributes in <p>" do
    render
  end
end
