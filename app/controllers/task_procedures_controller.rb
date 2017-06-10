class TaskProceduresController < ApplicationController
  before_action :set_task_procedure, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.intern?
      if current_user.procedures.where(id: params[:procedure_id]).empty?
        redirect_to root_path, alert: "Acceso denegado."
      else
        @procedure = Procedure.find(params[:procedure_id])
        @surgery = @procedure.surgery
      end
    else
      @procedure = Procedure.find(params[:procedure_id])
      @surgery = @procedure.surgery
    end
  end

  def show
  end

  def new
    if current_user.intern?
      if current_user.procedures.where(id: params[:procedure_id]).empty?
        redirect_to root_path, alert: "Acceso denegado."
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
  end

  def edit
  end

  def create
    @task_procedure = TaskProcedure.new(task_procedure_params)

    respond_to do |format|
      if @task_procedure.save
        format.html { redirect_to task_procedures_path(procedure: @task_procedure.procedure), notice: 'La actividad se ha creado satisfactoriamente.' }
        format.json { render :show, status: :created, location: @task_procedure }
      else
        format.html { render :new }
        format.json { render json: @task_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def destroy
    @task_procedure.destroy
    respond_to do |format|
      format.html { redirect_to task_procedures_url, notice: 'La actividad se ha eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  end

  private
    def set_task_procedure
      if current_user.intern?
        if current_user.procedures.where(id: params[:procedure_id]).empty?
          redirect_to root_path, alert: "Acceso denegado.."
        else
           @procedure = Procedure.find(params[:procedure_id])
        end
      else
         @procedure = Procedure.find(params[:procedure_id])
      end
    end

    def task_procedure_params
      params.require(:task_procedure).permit(:procedure_id, :task_id)
    end
end
