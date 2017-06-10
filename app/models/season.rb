class Season < ActiveRecord::Base
  # :startdate, :enddate
  validates :startdate, :enddate, presence: true
	has_many :users
end
