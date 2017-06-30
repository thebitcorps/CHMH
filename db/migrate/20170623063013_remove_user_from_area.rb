class RemoveUserFromArea < ActiveRecord::Migration
  def change
    remove_column :areas, :user_id, :integer
  end
end
