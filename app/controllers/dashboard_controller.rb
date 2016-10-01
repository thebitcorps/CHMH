class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_areas
  def index
    unless current_user.role == 'Admin' or current_user.role == '1' or current_user.role == '2'
      redirect_to root_path, :alert => "Acceso denegado."
    end
  end

  def monthly
    if current_user.role == 'Admin' or current_user.role == '1' or current_user.role == '2'
      @best_resident = Area.resident_more_notes_monthly(params[:month].to_i)
      @since = params[:month].to_i
    else
      redirect_to root_path, :alert => "Acceso denegado."
    end
  end

  def chart
    if current_user.role == 'Admin' or current_user.role == '1' or current_user.role == '2'
      @since = params[:month].to_i
    else
      redirect_to root_path, :alert => "Acceso denegado."
    end
  end
  private
  def set_areas
    @areas = Area.all

  end

  def area_params
    params.require(:dashboard).permit(:month)
  end
end
