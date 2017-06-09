class Surgery < ActiveRecord::Base
  # :name, :description, :area_id,
	validates :name, presence: true
	validates :description, presence: true
	belongs_to :area
	has_many :tasks, dependent: :destroy
  has_many :procedures
end
