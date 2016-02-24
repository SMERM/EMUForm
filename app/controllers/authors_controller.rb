class AuthorsController < EndUserBaseController
  before_action :set_work_and_author, except: [:create]

  # GET /authors
  # GET /authors.json
  def index
    @authors = @work.authors.order('last_name, first_name').uniq
  end

  # GET /works/:id/authors/1
  # GET /works/:id/authors/1.json
  def show
  end

  # GET /works/:id/authors/new
  def new
  end

  # GET /works/:id/authors/1/edit
  def edit
  end

  # POST /works/:id/authors
  # POST /works/:id/authors.json
  def create
    @work = current_account.works.where(params[:work_id]).uniq.first
    parms = params.has_key?(:author) ? author_params : nil
    (@author, roles_attrs) = Author.build(parms)

    respond_to do |format|
      if @author.save_with_work(@work, roles_attrs)
        format.html { redirect_to work_author_path(@work, @author), notice: 'Author was successfully created.' }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { redirect_to new_work_author_path(@work, @author) }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/:id/authors/1
  # PATCH/PUT /works/:id/authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to work_author_path(@work, @author), notice: 'Author was successfully updated.' }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/:id/authors/1
  # DELETE /works/:id/authors/1.json
  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to account_path, notice: 'Author was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_and_author
      @work = current_account.works.find(params[:work_id])
      @author = params.has_key?(:id) && params[:id] ? @work.authors.find(params[:id]) : @work.authors.build
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:first_name, :last_name, :birth_year, :bio_en, :bio_it, :owner_id, :work_id, :owner_id,
                                     works_attributes: [:id],
                                     roles_attributes: [:id])
    end
end
