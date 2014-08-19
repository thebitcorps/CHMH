class Surgery < ActiveRecord::Base
	validates :name, :presence => true
	validates :description, :presence => true
	belongs_to :area
	has_many :tasks
end
