class VisitorsController < ApplicationController
	before_filter :authenticate_user!

	def index
    if user_signed_in?
		@role = current_user.role
		if @role == "Admin"
			@season = Season.last
		end
		if @role.to_i <= 2
			@area = current_user.area
		end
    else
      redirect_to new_user_session_path, :alert => "Access denied."
    end
  end
end
