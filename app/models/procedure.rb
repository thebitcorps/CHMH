class Procedure < ActiveRecord::Base
  belongs_to :user
  belongs_to :surgery
  has_many :task_procedures
end
