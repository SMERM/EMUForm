class WorksController < EndUserBaseController

  layout 'file_upload', only: [:attach_file, :upload_file]

  before_action :set_work, except: [ :new, :index ]

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
  def create

    respond_to do |format|
      if @work.save
        format.html { redirect_to select_work_authors_path(@work), notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end

  end

  #
  # GET /work/1/attach_file
  # GET /work/1/attach_file.json
  # 
  # +attach_file+
  #
  # go to the form to add files
  #
  def attach_file
  end

  # POST /work/1/upload_file
  # POST /work/1/upload_file.json
  # 
  # +upload_file+
  #
  # upload the uploaded files to the indexed work
  #
  def upload_file
    @work.submitted_files_attributes = submitted_files_params[:submitted_files_attributes]
    respond_to do |format|
      if @work.save
        SubmissionConfirmation.confirm(@work).deliver_later
        format.html { redirect_to work_path(@work), notice: "#{@work.submitted_files.count} files were successefully uploaded." }
        format.json { render :attach_file, status: :ok, location: @work }
      else
        format.html { redirect_to attach_file_work_path(@work), notice: 'There were one or more errors uploading the files.' }
        format.json { render :attach_file, status: :unprocessable_entity, location: @work }
      end
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
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
      format.html { redirect_to works_path, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = params[:id].blank? ? current_account.works.new(work_params) : current_account.works.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    params.require(:work).permit(:title, :year, :duration, :instruments, :program_notes_en, :program_notes_it, :owner_id, :category_id,
                                authors_attributes: [ :id, roles_attributes: [ :id ] ])
  end

  def submitted_files_params
    params.require(:work).permit(submitted_files_attributes: [:http_request])
  end

end
