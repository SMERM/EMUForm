class PagesController < EndUserBaseController

  skip_before_action :authenticate_account!

  def terms
  end

  def welcome
  end

  def landing
  end

end
