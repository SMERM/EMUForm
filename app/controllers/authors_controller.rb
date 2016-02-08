class AuthorsController < EndUserBaseController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all.order('last_name, first_name').to_a
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
    @works = @author.works
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors
  # POST /authors.json
  def create
    parms = params.has_key?(:author) ? author_params : nil
    @author = current_account.authors.new(parms)

    respond_to do |format|
      if @author.save
        format.html { redirect_to author_path(@author), notice: 'Author was successfully created.' }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to author_path(@author), notice: 'Author was successfully updated.' }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    owner = @author.owner
    @author.destroy
    respond_to do |format|
      format.html { redirect_to account_path(owner), notice: 'Author was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = current_account.authors.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:first_name, :last_name, :birth_year, :bio_en, :bio_it, :owner_id)
    end
end
