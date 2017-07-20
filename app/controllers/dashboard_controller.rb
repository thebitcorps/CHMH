class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_areas

  def index
  end

  def monthly
    query = User.with_monthly_record(params[:month])
    @best_resident, @record_count = query
    @since = params[:month].to_i
  end

  def chart
      @since = params[:month].to_i
  end

  private

  def set_areas
    @areas = Area.all
    # authorize! :read, Area
  end

  def area_params
    params.require(:dashboard).permit(:month)
  end
end
