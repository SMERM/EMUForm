class WorksController < EndUserBaseController
  before_action :set_work, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_params, only: [:create, :update]

  # GET /works
  # GET /works.json
  def index
    @works = current_account.works.uniq
  end

  # GET /works/1
  # GET /works/1.json
  def show
    @authors = @work.authors
  end

  # GET /works/new
  def new
    @work = current_account.works.new
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  # POST //works.json
  #
  # +create+
  #
  # the +Work+ object created may carry along some file attachments that need to be uploaded
  # along with the +Work+ record. These files get loaded as +SubmittedFile+
  # and links to +author+ and +roles+.
  # Submitted files are uploaded on the fly before the response
  #
  def create
    parms = params.has_key?(:work) ? work_params(params) : nil
    @work = current_account.works.new(@cleaned_params)

    respond_to do |format|
      if @work.save
        @work.update_extra_features(@author, @roles, @submitted_files)
        format.html { redirect_to work_path(@work), notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(@cleaned_params)
        @work.update_extra_features(@authors, @roles, @submitted_files)
        format.html { redirect_to work_path(@work), notice: 'Work was successfully updated.' }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    owner = @work.owner
    @work.destroy
    respond_to do |format|
      format.html { redirect_to account_path, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = current_account.works.find(params[:id])
  end

  def set_extra_params
    (cp, as, rs, sfs) = Work.clean_args(params)
    @cleaned_params = work_params(cp)
    @authors = work_params(as)
    @roles = work_params(rs)
    @submitted_files = work_params(sfs)
    [@cleaned_params, @authors, @roles, @submitted_files]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params(parms)
    parms.require(:work).permit(:title, :year, :duration, :instruments, :program_notes_en, :program_notes_it, :owner_id,
                                authors_attributes: [:id, roles_attributes: [:id]],
                                submitted_files_attributes: [:id, :http_request, :filename, :content_type, :size, :_destroy],
                               )
  end

end
