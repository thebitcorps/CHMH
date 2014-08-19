class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :description
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
