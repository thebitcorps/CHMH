class RemoveAreaFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :area_id, :integer
  end
end
