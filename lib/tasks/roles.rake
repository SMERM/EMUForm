#
# +roles+
#
# tasks concerning roles pre-loading

require 'EMUForm/role_manager'

namespace :EMUForm do
  namespace :roles do
  
    #
    # +EMUForm:roles:setup+
    #
    # this task is used to pre-load the default static roles (which may be found
    # in `config/roles.yml` in the +roles+ table.
    # It does *not* duplicate roles if they are already present.
    #
    desc 'setup default static roles'
    task :setup => :environment do
      EMUForm::RoleManager.setup
    end
  
    #
    # +EMUForm:roles:clear+
    #
    # this task is used to clear the default static roles in the +roles+ table.
    # It does *not* clear roles that have been added subsequently.
    #
    desc 'clear default static roles'
    task :clear => :environment do
      EMUForm::RoleManager.clear
    end
  
  end
end
