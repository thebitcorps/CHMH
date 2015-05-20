class AddOwnerIdToExamined < ActiveRecord::Migration
  def change
    add_column :examineds, :owner_id, :integer
  end
end
