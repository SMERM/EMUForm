class AuthorsController < EndUserBaseController
  before_action :set_work_and_author, except: [ :create, :index ]
  before_action :set_work_and_authors, only: [:index]

  # GET /authors
  # GET /authors.json
  def index
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

  # GET /works/:id/authors/select
  def select
    @authors = []
    @all_authors = Author.all.order('last_name, first_name').uniq
  end

  # POST /works/:id/authors
  # POST /works/:id/authors.json
  def create
    params[:author].update(owner_id: current_account.to_param)
    r_attrs = params[:author].delete(:roles_attributes) || []
    @work = current_account.works.where(params[:work_id]).uniq.first
    @author = @work.authors.new(author_params)

    respond_to do |format|
      if @author.save
        a_attrs = HashWithIndifferentAccess.new(@author.attributes)
        a_attrs.update(roles_attributes: r_attrs)
        @work.update(authors_attributes: [ a_attrs ])
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
      format.html { redirect_to work_authors_path(@work), notice: 'Author was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = current_account.works.find(params[:work_id])
  end

  def set_work_and_author
    set_work
    @author = params.has_key?(:id) && params[:id] ? @work.authors.find(params[:id]) : @work.authors.build
  end

  def set_work_and_authors
    set_work
    @authors = @work.authors.order('last_name, first_name').uniq
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def author_params
    params.require(:author).permit(:first_name, :last_name, :birth_year, :bio_en, :bio_it, :owner_id, :work_id, :owner_id,
                                  roles_attributes: [:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def selected_authors_params
    params.require(:author).permit(authors_attributes: [:id])
  end
end
