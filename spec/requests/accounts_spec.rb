#         new_account_session GET        /accounts/sign_in(.:format)                  devise/sessions#new
#             account_session POST       /accounts/sign_in(.:format)                  devise/sessions#create
#     destroy_account_session DELETE     /accounts/sign_out(.:format)                 devise/sessions#destroy
#  account_omniauth_authorize GET|POST   /accounts/auth/:provider(.:format)           omniauth_callbacks#passthru {:provider=>/(?!)/}
#   account_omniauth_callback GET|POST   /accounts/auth/:action/callback(.:format)    omniauth_callbacks#(?-mix:(?!))
#            account_password POST       /accounts/password(.:format)                 devise/passwords#create
#        new_account_password GET        /accounts/password/new(.:format)             devise/passwords#new
#       edit_account_password GET        /accounts/password/edit(.:format)            devise/passwords#edit
#                             PATCH      /accounts/password(.:format)                 devise/passwords#update
#                             PUT        /accounts/password(.:format)                 devise/passwords#update
# cancel_account_registration GET        /accounts/cancel(.:format)                   devise/registrations#cancel
#        account_registration POST       /accounts(.:format)                          devise/registrations#create
#    new_account_registration GET        /accounts/sign_up(.:format)                  devise/registrations#new
#   edit_account_registration GET        /accounts/edit(.:format)                     devise/registrations#edit
#                             PATCH      /accounts(.:format)                          devise/registrations#update
#                             PUT        /accounts(.:format)                          devise/registrations#update
#                             DELETE     /accounts(.:format)                          devise/registrations#destroy
#
require 'rails_helper'

RSpec.describe "Accounts", type: :request do

  describe "GET /accounts/sign_up" do
    it "works! You can actually sign up" do
      get new_account_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /accounts/sign_in" do
    it "works! You can actually even sign in!" do
      get new_account_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /accounts/sign_in" do
    it "works! ... and you actually log in when you do that" do
      post account_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /accounts/sign_out" do
    it "works! and you cleanup after yourself when you're gone" do
      delete destroy_account_session_path({}, { :account_id => '1' })
      expect(response).to have_http_status(302) # you get redirected to sign_in
    end
  end

  # TODO: work out all the other ones

end
