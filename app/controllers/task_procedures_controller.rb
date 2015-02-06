class TaskProceduresController < ApplicationController
  before_action :set_task_procedure, only: [:show, :edit, :update, :destroy]

  # GET /task_procedures
  # GET /task_procedures.json
  def index
    if user_signed_in?
      if current_user.role == "3"
        if current_user.procedures.where(:id => params[:procedure_id]).empty?
          redirect_to root_path, :alert => "Acceso denegado."
        else
          @procedure = Procedure.find(params[:procedure_id])
          @surgery = @procedure.surgery
        end
      else
        @procedure = Procedure.find(params[:procedure_id])
        @surgery = @procedure.surgery
      end
    else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
  end

  # GET /task_procedures/1
  # GET /task_procedures/1.json
  def show
  end

  # GET /task_procedures/new
  def new
    if user_signed_in?
      if current_user.role == "3"
        if current_user.procedures.where(:id => params[:procedure_id]).empty?
          redirect_to root_path, :alert => "Acceso denegado."
        else
          @task_procedure = TaskProcedure.new
          @procedure = Procedure.find(params[:procedure_id])
          @surgery = @procedure.surgery
        end
      else
        @task_procedure = TaskProcedure.new
        @procedure = Procedure.find(params[:procedure_id])
        @surgery = @procedure.surgery
      end
    else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
  end

  # GET /task_procedures/1/edit
  def edit
  end

  # POST /task_procedures
  # POST /task_procedures.json
  def create
    @task_procedure = TaskProcedure.new(task_procedure_params)

    respond_to do |format|
      if @task_procedure.save
        format.html { redirect_to task_procedures_path(:procedure_id => @task_procedure.procedure.id), notice: 'La actividad se ha creado satisfactoriamente.' }
        format.json { render :show, status: :created, location: @task_procedure }
      else
        format.html { render :new }
        format.json { render json: @task_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_procedures/1
  # PATCH/PUT /task_procedures/1.json
  def update
    respond_to do |format|
      if @task_procedure.update(task_procedure_params)
        format.html { redirect_to @task_procedure.procedure, notice: 'La actividad ha sido correctamente actualizada.' }
        format.json { render :show, status: :ok, location: @task_procedure }
      else
        format.html { render :edit }
        format.json { render json: @task_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_procedures/1
  # DELETE /task_procedures/1.json
  def destroy
    @task_procedure.destroy
    respond_to do |format|
      format.html { redirect_to task_procedures_url, notice: 'La actividad se ha eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_procedure
      if user_signed_in?
        if current_user.role == "3"
          if current_user.procedures.where(:id => params[:procedure_id]).empty?
            redirect_to root_path, :alert => "Acceso denegado.."
          else
             @procedure = Procedure.find(params[:procedure_id])
          end
        else
           @procedure = Procedure.find(params[:procedure_id])
        end
      else
          redirect_to new_user_session_path, :alert => "Acceso denegado.."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_procedure_params
      params.require(:task_procedure).permit(:procedure_id, :task_id)
    end
end
