class SurgeriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_surgery, only: [:show, :edit, :update, :destroy]

  def query
    respond_to do |format|
      @surgery = Surgery.find(params[:id])
      @tasks = JSON.parse @surgery.tasks.to_json
      format.json {render json: @tasks}
    end
  end


  # GET /surgeries/1
  # GET /surgeries/1.json
  def show

  end

  # GET /surgeries/new
  def new
    if user_signed_in?
      if current_user.role == "Admin"
        @surgery = Surgery.new(:area_id => params[:area_id])
      else
        if current_user.role == "1"
          if current_user.area.id.to_i == params[:area_id].to_i
            @surgery = Surgery.new(:area_id => params[:area_id])
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

  # GET /surgeries/1/edit
  def edit
  end

  # POST /surgeries
  # POST /surgeries.json
  def create
    @surgery = Surgery.new(surgery_params)
    @surgery.name = @surgery.name.humanize
    respond_to do |format|
      if @surgery.save
        format.html { redirect_to @surgery, notice: 'El procedimiento se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @surgery }
      else
        format.html { render :new }
        format.json { render json: @surgery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surgeries/1
  # PATCH/PUT /surgeries/1.json
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

  # DELETE /surgeries/1
  # DELETE /surgeries/1.json
  def destroy
    @surgery.destroy
    areass = @surgery.area
    respond_to do |format|
      format.html { redirect_to area_path(areass), notice: 'El procedimiento ha sido eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_surgery
      if user_signed_in?
        if current_user.role == "Admin"
          @surgery = Surgery.find(params[:id])
        else
          if current_user.role == "1" or current_user.role == "2"
            @surgery = Surgery.find(params[:id])
            if current_user.area.id.to_i != @surgery.area.id.to_i
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
    def surgery_params
      params.require(:surgery).permit(:name, :description, :area_id)
    end
end
