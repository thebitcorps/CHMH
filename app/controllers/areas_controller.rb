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

  # GET /areas/1/edit
  def edit
    @users = User.where(:role => "1")
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(area_params)
    user = @area.user
    user.area = @area
    @users = User.where(:role => "1")

    @area.name = @area.name.titleize
    user.save
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

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
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

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Se ha eliminado el área correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      if user_signed_in?
        if current_user.admin?
          @area = Area.find(params[:id])
        else
          if current_user.role == "1"
            if current_user.area.id.to_i == params[:id].to_i
              @area = Area.find(params[:id])
            else
              redirect_to root_path, :alert => "Acceso denegado."
            end
          else
            redirect_to root_path, :alert => "Acceso denegado."
          end
        end
      else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:name, :description, :user_id)
    end
end
