class AreasController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  def show
    @surgeries = JSON.parse @area.surgeries.to_json
  end

  def new
    authorize! :create, Area
    @area = Area.new
    @users = User.head_of_area
  end

  def edit
    authorize! :update, @area
    @users = User.head_of_area
  end

  def create
    @area = Area.new(area_params)
    @area.name = @area.name.titleize

    respond_to do |format|
      if @area.save
        format.html { redirect_to @area, notice: 'Se ha creado el área correctamente.' }
        format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @area.update(area_params)
        @area.name = @area.name.titleize
        @area.save
        format.html { redirect_to @area, notice: 'El área se ha actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, Area
    @area.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Se ha eliminado el área correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    def set_area
      @area = Area.find(params[:id])
    end

    def area_params
      params.require(:area).permit(:name, :description, :user_id)
    end
end
