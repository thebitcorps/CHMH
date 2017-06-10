class RenameUserRoleToRickd < ActiveRecord::Migration
  def change
    rename_column :users, :role, :rickd
  end
end
