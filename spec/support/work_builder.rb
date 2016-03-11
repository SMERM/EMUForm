require_relative 'random_roles'

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

  #
  # +build_submitted_files_attributes(n_files)+ builds the proper argument for
  # submitted_files
  #
  def build_submitted_files_attributes(n_files)
    sfs = FactoryGirl.build_list(:submitted_file_without_association, n_files)
    res = sfs.map { |sf| sf.attributes }
    sfs.each_index { |idx| res[idx].update(:http_request => sfs[idx].http_request) }
    res
  end

end
