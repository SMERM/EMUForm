#require_relative '20160124072442_create_accounts'

class CreateAdminAccount < ActiveRecord::Migration

  def migrate(direction)
    super
    # create a default admin account (really? FIXME)
    AdminAccount.create!(:login_name => 'admin', :email => 'admin@emufest.org', :password => 'bimbomix', :password_confirmation => 'bimbomix') if direction == :up
  end

  def change
    #
    # the table has the same structure as Account
    #
    ca = ::CreateAccounts.new
    ca.change_table(:admin_accounts)
  end

end
