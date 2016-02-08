#         new_account_session GET        /accounts/sign_in(.:format)                  accounts/sessions#new
#             account_session POST       /accounts/sign_in(.:format)                  accounts/sessions#create
#     destroy_account_session DELETE     /accounts/sign_out(.:format)                 accounts/sessions#destroy
#  account_omniauth_authorize GET|POST   /accounts/auth/:provider(.:format)           accounts/omniauth_callbacks#passthru {:provider=>/(?!)/}
#   account_omniauth_callback GET|POST   /accounts/auth/:action/callback(.:format)    accounts/omniauth_callbacks#(?-mix:(?!))
#            account_password POST       /accounts/password(.:format)                 accounts/passwords#create
#        new_account_password GET        /accounts/password/new(.:format)             accounts/passwords#new
#       edit_account_password GET        /accounts/password/edit(.:format)            accounts/passwords#edit
#                             PATCH      /accounts/password(.:format)                 accounts/passwords#update
#                             PUT        /accounts/password(.:format)                 accounts/passwords#update
# cancel_account_registration GET        /accounts/cancel(.:format)                   accounts/registrations#cancel
#        account_registration POST       /accounts(.:format)                          accounts/registrations#create
#    new_account_registration GET        /accounts/sign_up(.:format)                  accounts/registrations#new
#   edit_account_registration GET        /accounts/edit(.:format)                     accounts/registrations#edit
#                             PATCH      /accounts(.:format)                          accounts/registrations#update
#                             PUT        /accounts(.:format)                          accounts/registrations#update
#                             DELETE     /accounts(.:format)                          accounts/registrations#destroy
#                             GET        /account/:id(.:format)                       accounts/accounts#show

require "rails_helper"

RSpec.describe Accounts::AccountsController, type: :routing do

  before :example do
    @auth_strategies = [:github, :twitter, :facebook, ] # TODO # :soundcloud, ]
  end

  describe "routing" do

    it "routes to sign in" do
      expect(:get => "/accounts/sign_in").to route_to("accounts/sessions#new")
    end

    it "routes to enter into the app" do
      expect(:post => "/accounts/sign_in").to route_to("accounts/sessions#create")
    end

    it "routes to exit from the app" do
      expect(:delete => "/accounts/sign_out").to route_to("accounts/sessions#destroy")
    end

    #  account_omniauth_authorize GET|POST   /accounts/auth/:provider(.:format)           omniauth_callbacks#passthru {:provider=>/(?!)/}
    #   account_omniauth_callback GET|POST   /accounts/auth/:action/callback(.:format)    omniauth_callbacks#(?-mix:(?!))

    it "routes to post an authorization" do
      @auth_strategies.each do
        |auths|
        expect(:post => "/accounts/auth/#{auths}").to route_to("accounts/omniauth_callbacks#passthru", :provider => auths.to_s)
      end
    end

    it "routes to query an authorization" do
      @auth_strategies.each do
        |auths|
        expect(:get => "/accounts/auth/#{auths}").to route_to("accounts/omniauth_callbacks#passthru", :provider => auths.to_s)
      end
    end

    it "routes to query authorization for an action" do
      @auth_strategies.each do
        |auths|
        expect(:get => "/accounts/auth/#{auths}/callback").to route_to("accounts/omniauth_callbacks##{auths.to_s}")
      end
    end

    it "routes to authorize an action" do
      @auth_strategies.each do
        |auths|
        expect(:post => "/accounts/auth/#{auths}/callback").to route_to("accounts/omniauth_callbacks##{auths.to_s}")
      end
    end

    it "routes to setting up a password" do
      expect(:post => "/accounts/password").to route_to("accounts/passwords#create")
    end

    it "routes to query for a new password" do
      expect(:get => "/accounts/password/new").to route_to("accounts/passwords#new")
    end

    it "routes to set up a new password (via PATCH)" do
      expect(:patch => "/accounts/password").to route_to("accounts/passwords#update")
    end

    it "routes to set up a new password (via PUT)" do
      expect(:put => "/accounts/password").to route_to("accounts/passwords#update")
    end

    it "routes to cancel an account" do
      expect(:get => "/accounts/cancel").to route_to("accounts/registrations#cancel", {}, { :id => 1 })
    end

    it "routes to create a new account (GET)" do
      expect(:get => "/accounts/sign_up").to route_to("accounts/registrations#new")
    end

    it "routes to create a new account (POST)" do
      expect(:post => "/accounts").to route_to("accounts/registrations#create")
    end

    it "routes to edit an account (GET)" do
      expect(:get => "/accounts/edit").to route_to("accounts/registrations#edit", {}, { :id => "1" })
    end

    it "routes to #update via PUT" do
      expect(:put => "/accounts").to route_to("accounts/registrations#update", {}, { :id => "1" })
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/accounts").to route_to("accounts/registrations#update", {}, { :id => "1" })
    end

    it "routes to #destroy" do
      expect(:delete => "/accounts").to route_to("accounts/registrations#destroy", {}, { :id => "1" })
    end

    it 'routes to #show' do
      expect(:get => "/account/").to route_to("accounts/accounts#show")
    end

  end
end
