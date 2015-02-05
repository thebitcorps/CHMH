class ProceduresController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_procedure, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      if current_user.role == "3"
        if current_user.id.to_i == params[:user_id].to_i
          @procedures = Procedure.where(:user_id => params[:user_id])
          @user = User.find(params[:user_id])
        else
          redirect_to root_path, :alert => "Access denied."
        end
      else
        @procedures = Procedure.where(:user_id => params[:user_id])
        @user = User.find(params[:user_id])
      end
    else
        redirect_to new_user_session_path, :alert => "Access denied."
    end
  end

  # GET /procedures/1
  # GET /procedures/1.json
  def show
  end

  # GET /procedures/new
  def new
    if user_signed_in?
        if current_user.role == "3"
          @procedure = Procedure.new
          @surgeries = Surgery.where(:area_id => current_user.area.id)
        else
          redirect_to root_path, :alert => "Access denied."
        end
      else
        redirect_to new_user_session_path, :alert => "Access denied."
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
    current_user.minutes = current_user.minutes.to_i + @procedure.minutes.to_i
    current_user.save
    respond_to do |format|
      if @procedure.save
        format.html { redirect_to @procedure, notice: 'Procedure was successfully created.' }
        format.json { render :show, status: :created, location: @procedure }
      else
        format.html { render :new }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /procedures/1

  # PATCH/PUT /procedures/1.json
  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
       
        format.html { redirect_to @procedure, notice: 'Procedure was successfully updated.' }
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
    @procedure.destroy
    respond_to do |format|
      format.html { redirect_to procedures_url, notice: 'Procedure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_procedure
      if user_signed_in?
        @procedure = Procedure.find(params[:id])
        if current_user.role == "3"
          if current_user.procedures.where(:id => @procedure.id).empty?
            redirect_to root_path, :alert => "Access denied."
          end
        end
      else
        redirect_to new_user_session_path, :alert => "Access denied."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def procedure_params
      params.require(:procedure).permit(:folio, :donedate, :notes, :user_id, :surgery_id, :task)
    end
end
