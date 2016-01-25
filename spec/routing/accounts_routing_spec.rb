#        account_registration POST       /accounts(.:format)                          devise/registrations#create
#         new_account_session GET        /accounts/sign_in(.:format)                  devise/sessions#new
#             account_session POST       /accounts/sign_in(.:format)                  devise/sessions#create
#     destroy_account_session DELETE     /accounts/sign_out(.:format)                 devise/sessions#destroy
#            account_password POST       /accounts/password(.:format)                 devise/passwords#create
#        new_account_password GET        /accounts/password/new(.:format)             devise/passwords#new
#       edit_account_password GET        /accounts/password/edit(.:format)            devise/passwords#edit
#                             PATCH      /accounts/password(.:format)                 devise/passwords#update
#                             PUT        /accounts/password(.:format)                 devise/passwords#update
# cancel_account_registration GET        /accounts/cancel(.:format)                   devise/registrations#cancel
#    new_account_registration GET        /accounts/sign_up(.:format)                  devise/registrations#new
#   edit_account_registration GET        /accounts/edit(.:format)                     devise/registrations#edit
#                             PATCH      /accounts(.:format)                          devise/registrations#update
#                             PUT        /accounts(.:format)                          devise/registrations#update
#                             DELETE     /accounts(.:format)                          devise/registrations#destroy

require "rails_helper"

RSpec.describe AccountsController, type: :routing do
  describe "routing" do

    it "routes to sign in" do
      expect(:get => "/accounts/sign_in").to route_to("devise/sessions#new")
    end

    it "routes to enter into the app" do
      expect(:post => "/accounts/sign_in").to route_to("devise/sessions#create")
    end

    it "routes to exit from the app" do
      expect(:delete => "/accounts/sign_out").to route_to("devise/sessions#destroy")
    end

    #  account_omniauth_authorize GET|POST   /accounts/auth/:provider(.:format)           omniauth_callbacks#passthru {:provider=>/(?!)/}
    #   account_omniauth_callback GET|POST   /accounts/auth/:action/callback(.:format)    omniauth_callbacks#(?-mix:(?!))

    it "routes to get an authorization" do
      skip('waiting to understand this routing :-(')
      expect(:get => "/accounts/auth/whatever").to route_to("omniauth_callbacks#passthru", { :provider => 'whatever' })
    end

    it "routes to post an authorization" do
      skip('waiting to understand this routing :-(')
      expect(:post => "/accounts/auth/whatever").to route_to("omniauth_callbacks#passthru", { :provider => 'whatever' })
    end

    it "routes to query authorization for an action" do
      skip('waiting to understand this routing :-(')
      expect(:get => "/accounts/auth/whatever/callback").to route_to("omniauth_callbacks#", { :action => 'whatever' })
    end

    it "routes to authorize an action" do
      skip('waiting to understand this routing :-(')
      expect(:post => "/accounts/auth/whatever/callback").to route_to("omniauth_callbacks#", { :action => 'whatever' })
    end

    it "routes to setting up a password" do
      expect(:post => "/accounts/password").to route_to("devise/passwords#create")
    end

    it "routes to query for a new password" do
      expect(:get => "/accounts/password/new").to route_to("devise/passwords#new")
    end

    it "routes to set up a new password (via PATCH)" do
      expect(:patch => "/accounts/password").to route_to("devise/passwords#update")
    end

    it "routes to set up a new password (via PUT)" do
      expect(:put => "/accounts/password").to route_to("devise/passwords#update")
    end

    it "routes to cancel an account" do
      expect(:get => "/accounts/cancel").to route_to("devise/registrations#cancel", {}, { :id => 1 })
    end

    it "routes to create a new account (GET)" do
      expect(:get => "/accounts/sign_up").to route_to("devise/registrations#new")
    end

    it "routes to create a new account (POST)" do
      expect(:post => "/accounts").to route_to("devise/registrations#create")
    end

    it "routes to edit an account (GET)" do
      expect(:get => "/accounts/edit").to route_to("devise/registrations#edit", {}, { :id => "1" })
    end

    it "routes to #update via PUT" do
      expect(:put => "/accounts").to route_to("devise/registrations#update", {}, { :id => "1" })
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/accounts").to route_to("devise/registrations#update", {}, { :id => "1" })
    end

    it "routes to #destroy" do
      expect(:delete => "/accounts").to route_to("devise/registrations#destroy", {}, { :id => "1" })
    end

  end
end
