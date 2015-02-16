class DashboardController < ApplicationController
  def index
    @areas  =  Area.all
  end

  def monthly
    @areas  =  Area.all
    @best_resident = Area.resident_with_more_notes

  end
end
