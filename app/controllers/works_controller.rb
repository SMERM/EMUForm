class WorksController < EndUserBaseController
  layout 'works'
  before_action :set_author
  before_action :set_extra_params, only: [:create, :update]

  # GET authors/1/works
  # GET authors/1/works.json
  def index
    @works = @author.works_with_roles
  end

  # GET /authors/1/works/1
  # GET /authors/1/works/1.json
  def show
    @work = @author.works.find(params[:id])
  end

  # GET /authors/1/works/new
  def new
    @work = @author.works.new
  end

  # GET /authors/1/works/1/edit
  def edit
    @work = @author.works.find(params[:id])
  end

  # POST /authors/1/works
  # POST /authors/1//works.json
  #
  # +create+
  #
  # the +Work+ object created may carry along some file attachments that need to be uploaded
  # along with the +Work+ record. These files get loaded as +SubmittedFile+
  # and links to +author+ and +roles+.
  # Submitted files are uploaded on the fly before the response
  #
  def create
    @work = @author.works.new(@cleaned_params)

    respond_to do |format|
      if @work.save
        @work.update_extra_features(@author, @roles, @submitted_files)
        format.html { redirect_to author_work_path(@author, @work), notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /authors/1/works/1
  # PATCH/PUT /authors/1/works/1.json
  def update
    @work = @author.works.find(params[:id])

    respond_to do |format|
      if @work.update(@cleaned_params)
        @work.update_extra_features(@author, @roles, @submitted_files)
        format.html { redirect_to author_work_path(@author, @work), notice: 'Work was successfully updated.' }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE authors/1/works/1
  # DELETE authors/1/works/1.json
  def destroy
    @work = @author.works.find(params[:id])
    @work.destroy
    respond_to do |format|
      format.html { redirect_to author_path(@author), notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = Author.find(params[:author_id])
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
    parms.require(:work).permit(:title, :year, :duration, :instruments, :program_notes_en, :program_notes_it,
                                :roles_attributes => [:id],
                                :authors_attributes => [:id],
                                :submitted_files_attributes => [:id, :http_request, :filename, :content_type, :size, :_destroy]
                               )
  end

end
