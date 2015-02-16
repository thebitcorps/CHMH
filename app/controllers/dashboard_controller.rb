class DashboardController < ApplicationController
  def index

    @areas  =  Area.all

  end
end
