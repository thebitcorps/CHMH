class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :lastname, :string
    add_column :users, :birthday, :date
    add_column :users, :role, :string
    add_column :users, :gender, :string, :limit => 1
    add_column :users, :minutes, :integer
  end
end
