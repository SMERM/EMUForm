#
# +EMUForm::RoleManager+
#
# handles loading/clearing of static roles
#
module EMUForm

  module RoleManager

    class << self

      #
      # +setup+
      #
      # pre-loads the default static roles in the +roles+ table
      # It does *not* duplicate roles if they are already present.
      #
      def setup
        load_static_role_names
        @static_roles.each { |r| Role.create(:description => r, :static => true) if Role.where('description = ?').empty? }
      end

      #
      # +clear+
      #
      # clears the default static roles in the +roles+ table
      # It does *not* clear roles that have been added subsequently.
      #
      def clear
        static_roles.each { |r| r.destroy }
        @static_roles = nil
      end

      #
      # +static_role_names+
      #
      # returns the list of static roles names
      #
      def static_role_names
        load_static_role_names
      end

      #
      # +static_roles+
      #
      # returns the list of static roles
      #
      def static_roles
        Role.where('static = ?', true)
      end

    private

      ROLE_CONFIG_PATH = File.join(Rails.root, 'config', 'roles.yml')

      def load_static_role_names
        @static_roles ||= YAML.load(File.open(ROLE_CONFIG_PATH, 'r')).keys
      end

    end

  end

end
