class AddExaminedToProcedures < ActiveRecord::Migration
  def change
    add_column :procedures, :examined, :boolean, default: false
  end
end
