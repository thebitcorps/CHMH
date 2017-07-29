class ExaminedController < ApplicationController
  before_filter :authenticate_user!

  def not_examined
    @user =  User.find(params[:user_id])
  end

  def create
    authorize! :create, Examined
    new_examined(params[:procedure_id])
  end

  def destroy
    authorize! :destroy, Examined
    destroy_examined(params[:procedure_id])
  end

  private

  def new_examined(procedure)
    procedure = Procedure.find(procedure)
    examined = Examined.find_or_create_by(procedure: procedure, user: current_user)
    respond_to do |format|
      if examined.save
        format.js {  @procedure = procedure}
        format.html { redirect_to session.delete(:return_to), notice: 'Nota revisada.' }
      else
        format.html { redirect_to procedure, notice: 'Error nota no revisada.' }
      end
    end
  end

  def destroy_examined(procedure)
    examined = Examined.where(procedure: procedure, user: current_user)
    examined.destroy_all

    respond_to do |format|
      format.js {  @procedure = Procedure.find procedure }
      format.html { redirect_to :back, notice: 'No Revisado' }
    end
  end

  def user_params
    params.require(:procedure_id).permit(:user_id)
  end
end
