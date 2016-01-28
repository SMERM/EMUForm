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
        srns = load_static_role_names
        srns.each { |r| Role.create(:description => r) if Role.where('description = ?').empty? }
      end

      #
      # +clear+
      #
      # clears the default static roles in the +roles+ table
      # It does *not* clear roles that have been added subsequently.
      #
      def clear
        srns = load_static_role_names
        srns.each { |r| Role.where('description = ?', r).each { |rf| rf.destroy } }
      end

    private

      ROLE_CONFIG_PATH = File.join(Rails.root, 'config', 'roles.yml')

      def load_static_role_names
        YAML.load(File.open(ROLE_CONFIG_PATH, 'r')).keys.sort
      end

    end

  end

end
