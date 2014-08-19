class CreateTaskProcedures < ActiveRecord::Migration
  def change
    create_table :task_procedures do |t|
      t.belongs_to :procedure, index: true
      t.belongs_to :task, index: true

      t.timestamps
    end
  end
end
