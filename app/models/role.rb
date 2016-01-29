require 'EMUForm/role_manager'

module RoleStaticMethods

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    EMUForm::RoleManager.static_role_names.each do
      |sr|
      srname = sr.gsub(/\s+/,'').underscore.to_sym
      define_method(srname) { where('description = ?', sr).first }
    end

  end

end

class Role < ActiveRecord::Base
  validates :description, presence: true, uniqueness: true

  has_many :author_work_roles
  has_many :authors, through: :author_work_roles
  has_many :works, through: :author_work_roles

  include RoleStaticMethods
end
