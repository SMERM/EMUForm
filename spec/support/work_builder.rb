require_relative 'random_roles'
require_relative 'submitted_files_helper'

module WorkBuilderSpecHelper

  include RandomRoles
  #
  # +build_authors_and_roles_attributes(authors, n_roles)+
  #
  # builds the proper authors_attributes argument
  #
  # we need to simulate the behaviour of the view. For this reason we add an
  # extra empty 'id' element to the roles (needed by the checkbox collection).
  #
  def build_authors_and_roles_attributes(authors, n_roles)
    res = []
    authors.each do
      |a|
      roles = select_random_roles(n_roles)
      roles_h = roles.uniq.map { |r| { id: r.to_s } }
      roles_h << { id: '' } # empty (wrong) element added by the view
      h = HashWithIndifferentAccess.new(id: a.to_param, roles_attributes: roles_h)
      res << h
    end
    res
  end

  include SubmittedFilesHelper
  #
  # +build_submitted_files_attributes(n_files)+ builds the proper argument for
  # submitted_files
  #
  def build_submitted_files_attributes(n_files)
    hrs = []
    1.upto(n_files) do
      hrs << get_an_http_request_to_submit
    end
    hrs.map { |hr| { http_request: hr } }
  end

end
