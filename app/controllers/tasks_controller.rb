class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  def new
    authorize! :create, Task
    # if current_user.administrator?
    @task = Task.new(surgery_id: params[:surgery_id])
    # else
    # if current_user.area.id.to_i == Surgery.find(params[:surgery_id]).area.id.to_i
    # @task = Task.new(:surgery_id => params[:surgery_id])
  end

  def edit
  end

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

  def destroy
    @task.destroy
    sugeryass = @task.surgery
    respond_to do |format|
      format.html { redirect_to surgery_path(sugeryass), notice: 'La actividad se ha eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :surgery_id)
    end
end
