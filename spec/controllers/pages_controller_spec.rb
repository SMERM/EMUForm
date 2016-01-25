require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  let(:valid_session) { {} }

  it 'get to the landing page if given the bare domain name' do
    get :landing, {}, valid_session
  end

end
