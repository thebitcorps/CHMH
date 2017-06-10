class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_areas

  def index
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
    authorize! :read, Area
  end

  def area_params
    params.require(:dashboard).permit(:month)
  end
end
