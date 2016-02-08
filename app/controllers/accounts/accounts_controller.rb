class Accounts::AccountsController < EndUserBaseController

  before_action :set_account
  #
  # GET /accounts/accounts/1
  #
  # +show+ is the only allowed method for accounts
  #
  # It should show the account page (which lists all owned authors and possibly
  # works connected to them)
  #
  def show
  end

private

  def set_account
    @account = current_account 
  end

end
