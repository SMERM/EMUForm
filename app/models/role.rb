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

  has_many :works_roles_authors
  has_many :works, through: :works_roles_authors, source: :work, dependent: :destroy
  has_many :authors, through: :works_roles_authors, source: :author, dependent: :destroy

  include RoleStaticMethods

  class << self

    def static_roles
      where('static = ?', true).order(:description)
    end

    def ordered_all
      all.order('static DESC, description')
    end

  end

end
