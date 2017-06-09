class Season < ActiveRecord::Base
  # :startdate, :enddate
	has_many :users
end
