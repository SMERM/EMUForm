module RandomRoles

  #
  # +select_random_roles(n_roles)+
  #
  # select a batch of random roles
  #
  def select_random_roles(n_roles)
    roles = []
    1.upto(n_roles) { roles << Forgery(:basic).unique_number(roles, :at_least => 1, :at_most => Role.count) }
    roles
  end

end
