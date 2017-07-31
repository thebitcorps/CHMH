class SurgeriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_surgery, only: [:show, :edit, :update, :destroy]

  def query
    respond_to do |format|
      @surgery = Surgery.find(params[:id])
      @tasks = JSON.parse @surgery.tasks.to_json
      format.json {render json: @tasks}
    end
  end

  def show
    @tasks = JSON.parse @surgery.tasks.to_json
  end

  def new
    @surgery = Surgery.new(area_id: params[:area_id])
  end

  def edit
  end

  def create
    @surgery = Surgery.new(surgery_params)
    @surgery.name = @surgery.name.humanize
    respond_to do |format|
      if @surgery.save
        format.html { redirect_to @surgery, notice: 'El procedimiento se ha creado correctamente.' }
        format.json {render json: JSON.parse(@surgery.to_json) }
      else
        format.html { render :new }
        format.json { render json: @surgery.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @surgery.update(surgery_params)
        @surgery.name = @surgery.name.humanize
        @surgery.save
        format.html { redirect_to @surgery, notice: 'El procedimiento se ha actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @surgery }
      else
        format.html { render :edit }
        format.json { render json: @surgery.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @surgery.destroy
    areass = @surgery.area
    respond_to do |format|
      format.html { redirect_to area_path(areass), notice: 'El procedimiento ha sido eliminado satisfactoriamente.' }
      format.json { render json: @surgery.to_json, status: :ok }
    end
  end

  private
    def set_surgery
      @surgery = Surgery.find(params[:id])
    end

    def surgery_params
      params.require(:surgery).permit(:name, :description, :area_id)
    end
end
