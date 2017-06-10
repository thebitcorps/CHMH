class Task < ActiveRecord::Base
  #:name, :description, :surgery_id
	validates :name, :description, presence: true
	belongs_to :surgery
end
