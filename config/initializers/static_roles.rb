require 'EMUForm/role_manager'

#
# Make sure static roles exist for the environment selected, otherwise create
# them.
#
EMUForm::RoleManager.setup
