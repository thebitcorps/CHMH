class VisitorsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @role = current_user.access_level
    @season = Season.last if current_user.admin?
    @area = current_user.area if ['head_of_area', 'tutor'].include? @role
  end
end
