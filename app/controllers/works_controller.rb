class WorksController < ApplicationController
  layout 'application'
  before_action :set_author_and_works, except: :index

  # GET authors/1/works
  # GET authors/1/works.json
  def index
    @author = Author.find(params[:author_id])
    @works = @author.works
  end

  # GET /authors/1/works/1
  # GET /authors/1/works/1.json
  def show
    @works = @author.works
  end

  # GET /authors/1/works/new
  def new
  end

  # GET /authors/1/works/1/edit
  def edit
  end

  # POST /authors/1/works
  # POST /authors/1//works.json
  #
  # +create+
  #
  # the +Work+ object created may carry along some file attachments that need to be uploaded
  # along with the +Work+ record. These files get loaded as +SubmittedFile+
  # object and are uploaded on the fly before the response (FIXME: is this right?)
  #
  def create
    @work = @author.works.new(work_params)

    respond_to do |format|
      if @work.save
        create_submitted_files
        @work.reload # this is to include the submitted files
        format.html { redirect_to author_path(@author), notice: 'Work was successfully created.' }
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
      if @work.update(work_params)
        format.html { redirect_to author_path(@author), notice: 'Work was successfully updated.' }
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
    @work.destroy
    respond_to do |format|
      format.html { redirect_to author_path(@author), notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_author_and_works
    @author = Author.find(params[:author_id])
    @work = params[:id] ? @author.works.find_or_initialize_by("id = #{params[:id]}") : @author.works.new
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    params.require(:work).permit(:id, :title, :year, :duration, :instruments, :program_notes_en, :program_notes_it,
                                 :submitted_files_attributes => [:id, :http_request, :_destroy])
  end

  # create submitted file dependent records, if any
  def create_submitted_files
    if work_params.has_key?(:submitted_files_attributes)
      work_params[:submitted_files_attributes].each do
        |att|
        att.update(:work => @work)
        sf = SubmittedFile.create(att)
        sf.upload
      end
    end
  end

end
