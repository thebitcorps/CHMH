class ProceduresController < ApplicationController
  # before_filter :authenticate_user!
  before_action :set_procedure, only: [:show, :edit, :update, :destroy, :query]

  def index
    @user = User.find(params[:user_id])
    @procedures = Procedure.from_user(@user).group(:surgery).count
    @procedure = Procedure.from_user(@user).to_a

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    session[:return_to] ||= request.referer
  end

  def new
    authorize! :create, Procedure
    @procedure = Procedure.new
    @surgeries = Surgery.where(area: current_user.area)
    @surgeries_json = JSON.parse(Surgery.where(area: current_user.area).to_json)
  end

  def edit
  end

  def create
    @procedure = Procedure.new(procedure_params)
    @procedure.user = current_user
    @procedure.minutes = params["hou"].to_i * 60 + params["min"].to_i
    @procedure.create_procedure_tasks(params[:task_procedure_ids])
    @surgeries = Surgery.where(area: current_user.area)
    current_user.minutes += @procedure.minutes.to_i
    current_user.save!

    respond_to do |format|
      if @procedure.save
        format.html { redirect_to @procedure, notice: 'La actividad se ha creado correctamente.' }
        format.json { render json: JSON.parse( @procedure.to_json)}

      else
        format.html { render :new }
        format.json { render json: JSON.parse(@procedure.errors.full_messages.to_json), status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
        format.html { redirect_to @procedure, notice: 'La actividad se ha actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @procedure }
      else
        format.html { render :edit }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    user = @procedure.user
    user.minutes -= @procedure.minutes
    user.save!
    @procedure.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'La actividad se ha eliminado correctamente.' }
      format.json { head :no_content }
    end
  end

  def monthly
    set_notes
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_examined
    @user = User.find(params[:user_id])
    #all the types of procedures the user did
    @procedures = @user.last_month_notes(@since).order('surgery_id DESC').group(:surgery).count
    #the actual procedures orden so we can show in group of types
    @procedure = @user.last_month_notes(@since).order('surgery_id DESC').to_a
  end

  #set the variables for montlhy view with the last month oraganize per type
  def set_notes
    @since = params[:month].to_i
    @user = User.find(params[:user_id])
    #all the types of procedures the user did
    @procedures = @user.last_month_notes(@since).order('surgery_id DESC').group(:surgery).count
    #the actual procedures orden so we can show in group of types
    @procedure = @user.last_month_notes(@since).order('surgery_id DESC').to_a
  end

  def set_procedure
    @procedure = Procedure.find(params[:id])
    # check for ownership somewhere... ?
  end

  def procedure_params
    params.require(:procedure).permit(:folio, :donedate, :notes, :user_id, :surgery_id, :task,:month,:examid, :task_procedure_ids => [])
  end
end
