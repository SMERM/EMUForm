require 'rails_helper'

RSpec.describe "works/index", type: :view do
  before(:each) do
    params = {
      :title => 'Test', :year => '2012-01-01', :duration => '03:03:03', :instruments => 'pno, fl, cl', :program_notes_en => 'Test notes',
      :program_notes_it => 'Note di Test'
    }
    assign(:works, [
      Work.create!(params),
      Work.create!(params)
    ])
  end

  it "renders a list of works" do
    render
  end
end
