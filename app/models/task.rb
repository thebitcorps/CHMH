class Task < ActiveRecord::Base
	validates :name, :description, presence: true
	belongs_to :surgery
end
