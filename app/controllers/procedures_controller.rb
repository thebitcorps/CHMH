class ProceduresController < ApplicationController
  # before_filter :authenticate_user!
  before_action :set_procedure, only: [:show, :edit, :update, :destroy,:query]



  def index
    if user_signed_in?
      if current_user.role == "3"
        if current_user.id.to_i == params[:user_id].to_i
          # @procedures = Procedure.where(:user_id => params[:user_id])
          @user = User.find(params[:user_id])
          @procedures = Procedure.from_user(@user.id).group(:surgery).count
          @procedure =  Procedure.from_user(@user.id).to_a
        else
          redirect_to root_path, :alert => "Acceso denegado."
        end
      else
        @user = User.find(params[:user_id])
        @procedures = Procedure.from_user(@user.id).group(:surgery).count
        @procedure =  Procedure.from_user(@user.id).to_a
      end
    else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  # GET /procedures/1
  # GET /procedures/1.json
  def show
    # session[:return_to] ||= request.referer
    @user = @procedure.user
    @unchecked_procedures = Procedure.unexamined(@user)
  end

  # GET /procedures/new
  def new
    if user_signed_in?
        if current_user.role == "3"
          @procedure = Procedure.new
          @surgeries = Surgery.where(:area_id => current_user.area.id)
          @surgeries_json = JSON.parse Surgery.where(:area_id => current_user.area.id).to_json
        else
          redirect_to root_path, :alert => "Acceso denegado."
        end
      else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
   
  end

  # GET /procedures/1/edit
  def edit
  end

  # POST /procedures
  # POST /procedures.json
  def create
    @procedure = Procedure.new(procedure_params)
    @procedure.user = current_user
    @procedure.minutes = params["hou"].to_i * 60 + params["min"].to_i
    @procedure.create_procedure_tasks( params[:task_procedure_ids])
    @surgeries = Surgery.where(:area_id => current_user.area.id)
    current_user.minutes = current_user.minutes.to_i + @procedure.minutes.to_i
    current_user.save

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

  # PATCH/PUT /procedures/1

  # PATCH/PUT /procedures/1.json
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

  # DELETE /procedures/1
  # DELETE /procedures/1.json
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
      if current_user.role == "3"
        #if resident only can see own
        if current_user.id.to_i == params[:user_id].to_i
          set_notes
        else
          redirect_to root_path, :alert => "Acceso denegado."
        end
      else
          set_notes
      end
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

    # Use callbacks to share common setup or constraints between actions.
    def set_procedure
      if user_signed_in?
        @procedure = Procedure.find(params[:id])
        if current_user.role == "3"
          if current_user.procedures.where(:id => @procedure.id).empty?
            redirect_to root_path, :alert => "Acceso denegado."
          end
        end
      else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def procedure_params
      params.require(:procedure).permit(:folio, :donedate, :notes, :user_id, :surgery_id, :task,:month,:examid, :task_procedure_ids => [])
    end


end
