class TaskProcedure < ActiveRecord::Base
  #many to many join model
  belongs_to :procedure
  belongs_to :task
end
