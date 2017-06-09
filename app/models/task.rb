class Task < ActiveRecord::Base
  #:name, :description, :surgery_id
	validates :name, presence: true
	validates :description, presence: true
	belongs_to :surgery
end
