class Area < ActiveRecord::Base
	validates :name, :presence => true
	validates :description, :presence => true
	belongs_to :user
	has_many :users
	has_many :surgeries
end
