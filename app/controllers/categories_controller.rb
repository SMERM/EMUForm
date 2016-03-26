class CategoriesController < AdminBaseController
  before_action :set_category, except: [ :create, :index  ]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all.to_a
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to category_path(@category), notice: 'Category was successfully created and made current.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { redirect_to new_category_path(@category) }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_path(@category), notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = params[:id] ? Category.find(params[:id]) : Category.new
  end

  def category_params
    params.require(:category).permit(:acro, :title_en, :title_it, :description_en, :description_it)
  end
end
