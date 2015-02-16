class DashboardController < ApplicationController
  before_action :set_areas
  def index
  end

  def monthly
    @best_resident = Area.resident_with_more_notes
    @since = params[:month].to_i
  end
  private
  def set_areas
    @areas = Area.all

  end

  def area_params
    params.require(:dashboard).permit(:month)
  end
end
