class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  # GET /tasks/new
  def new
    if user_signed_in?
      if current_user.role == "Admin"
        @task = Task.new(:surgery_id => params[:surgery_id])
      else
        if current_user.role == "1"
          if current_user.area.id.to_i == Surgery.find(params[:surgery_id]).area.id.to_i
            @task = Task.new(:surgery_id => params[:surgery_id])
          else
            redirect_to root_path, :alert => "Access denied."
          end
        else
          redirect_to root_path, :alert => "Access denied."
        end
      end
    else
      redirect_to new_user_session_path, :alert => "Access denied."
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.name = @task.name.humanize
    respond_to do |format|
      if @task.save
        format.html { redirect_to surgery_path(@task.surgery), notice: 'La actividad se ha creado satisfactoriamente.' }
        format.json { render json: JSON.parse(@task.to_json )}
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        @task.name = @task.name.humanize
        @task.save
        format.html { redirect_to surgery_path(@task.surgery), notice: 'La actividad ha sido correctamente actualizada.' }
        format.json { render json: JSON.parse(@task.to_json) }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    sugeryass = @task.surgery
    respond_to do |format|
      format.html { redirect_to surgery_path(sugeryass), notice: 'La actividad se ha eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :surgery_id)
    end
end
