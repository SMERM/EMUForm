class EditionsController < AdminBaseController
  before_action :set_edition, except: [ :create, :index  ]

  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.all.to_a
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
  end

  # GET /editions/new
  def new
  end

  # GET /editions/1/edit
  def edit
  end

  # POST /editions
  # POST /editions.json
  def create
    @edition = Edition.switch(edition_params)

    respond_to do |format|
      if @edition.save
        format.html { redirect_to edition_path(@edition), notice: 'Edition was successfully created and made current.' }
        format.json { render :show, status: :created, location: @edition }
      else
        format.html { redirect_to new_edition_path(@edition) }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /editions/1
  # PATCH/PUT /editions/1.json
  def update
    respond_to do |format|
      if @edition.update(edition_params)
        format.html { redirect_to edition_path(@edition), notice: 'Edition was successfully updated.' }
        format.json { render :show, status: :ok, location: @edition }
      else
        format.html { render :edit }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/:id/editions/1
  # DELETE /works/:id/editions/1.json
  def destroy
    @edition.destroy
    respond_to do |format|
      format.html { redirect_to editions_path, notice: 'Edition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_edition
    @edition = params[:id] ? Edition.find(params[:id]) : Edition.send(:new)
  end

  def edition_params
    params.require(:edition).permit(:year, :title, :start_date, :end_date, :description_en, :description_it, :submission_deadline)
  end
end

