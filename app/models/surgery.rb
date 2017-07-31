class Surgery < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  belongs_to :area
  has_many :tasks, dependent: :destroy
  has_many :procedures
end
