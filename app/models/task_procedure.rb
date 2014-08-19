class TaskProcedure < ActiveRecord::Base
  belongs_to :procedure
  belongs_to :task
end
