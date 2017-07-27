class ExaminedController < ApplicationController
  before_filter :authenticate_user!
  
  
  def not_examined
    @user =  User.find params[:user_id]
  end

  def create
    if current_user.role == 'Admin'
      new_examined(params[:procedure_id])
    elsif current_user.role == '1' or current_user.role == '2'
      procedure = Procedure.find params[:procedure_id]
      if current_user.area == procedure.user.area
          new_examined(params[:procedure_id])
      end
    else
      redirect_to new_user_session_path, :alert => "Acceso denegado."
    end

  end

  def destroy
    if current_user.role == 'Admin'
      destroy_examined params[:procedure_id]
    elsif current_user.role == '1' or current_user.role == '2'
      procedure = Procedure.find params[:procedure_id]
      if current_user.area == procedure.user.area
        destroy_examined params[:procedure_id]
      end
    else
      redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
  end

  private

  def destroy_examined(procedure_id)
    examined = Examined.where(procedure_id: procedure_id, user_id: current_user.id)
    examined.destroy_all

    respond_to do |format|
      format.js {  @procedure = Procedure.find procedure_id}
      format.html{ redirect_to :back, notice: 'No Revisado' }
    end
  end

  def new_examined(procedure_id)
    procedure = Procedure.find procedure_id
    examined = Examined.find_or_create_by(procedure_id: procedure_id, user_id: current_user.id)
    respond_to do |format|
      if examined.save
        format.js {  @procedure = procedure}
        format.html { redirect_to session.delete(:return_to), notice: 'Nota revisada.' }
      else
        format.html { redirect_to procedure, notice: 'Error nota no revisada.' }
      end
    end
  end

  def user_params
    params.require(:procedure_id).permit(:user_id)
  end
end
