class WorksRolesAuthorsController < EndUserBaseController

  before_action :set_work

  #
  # TODO: in the remote ajax actions: instead of render do:
  #
  # head :created, location: @work
  # or
  # head :bad_request, location: @work
  #

  #
  # POST /works/:work_id/works_roles_authors(.:format)
  #
  def create
    cache = load_cache
    respond_to do |format|
      if save_cache(cache)
        format.html { redirect_to attach_file_work_path(@work), notice: 'Work was successfully created and connected to authors and roles.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { redirect_to select_work_authors_path(@work), notice: 'Failed to created a full connection between this work, authors and roles' }
        format.json { render :show, status: :created, location: @work }
      end
    end
  end

private
  #
  # <tt>save_cache(cache)</tt>
  #
  # it creates a cache of *only* those links that are not already there
  # If one of the elements of the cache fails to save it aborts returning false
  #
  def save_cache(cache)
    res = true
    cache.each do
      |el|
      unless el.exists?
        this_res = el.save
        unless this_res
          res = this_res
          break
        end
      end
    end
    res
  end

  #
  # <tt>load_cache</tt>
  #
  # +load_cache+ loads an array with all the WRA objects to be saved later on.
  #
  def load_cache
    res = []
    works_roles_authors_params[:authors_attributes].each do
      |a|
      a[:roles_attributes].each { |r| (res << WorkRoleAuthor.new(work_id: @work.to_param, author_id: a[:id], role_id: r[:id])) unless r[:id].blank? } unless a[:id].blank?
    end
    res
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def works_roles_authors_params
    params.require(:works_roles_authors).permit(authors_attributes: [:id, roles_attributes: [:id]])
  end

  #
  # +set_work+
  #
  # picks up the work from params and sets it up
  #
  def set_work
    @work = Work.find(params[:work_id])
  end

end
