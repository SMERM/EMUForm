# +AdminBaseController+
#
# This class is intended to be a superclass from which
# the other (admin related) controller classes inherit
#
class AdminBaseController < ApplicationController

  layout 'admin'

  before_filter :authenticate_admin_account!

end
