class VisitorsController < ApplicationController
	before_filter :authenticate_user!

	def index
    @role = current_user.roles.first.try(:name)
    if @role == 'administrator'
      @season = Season.last
    else
      @area = current_user.area
    end
  end
end
