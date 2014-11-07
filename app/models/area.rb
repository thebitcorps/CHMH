class Area < ActiveRecord::Base
	validates :name, :presence => true
	validates :description, :presence => true
	belongs_to :user
	has_many :users,  dependent: :nullify
	has_many :surgeries 
end
