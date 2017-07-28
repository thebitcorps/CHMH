class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_areas
  def index
    authorize! :read, Dashboard
  end

  def monthly
    @best_resident = Area.resident_more_notes_monthly(params[:month].to_i)
    @since = params[:month].to_i
  end

  def chart
    @since = params[:month].to_i
  end

private
  def set_areas
    @areas = Area.all
  end

  def area_params # not used
    params.require(:dashboard).permit(:month)
  end
end
