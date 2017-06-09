class CreateSurgeries < ActiveRecord::Migration
  def change
    create_table :surgeries do |t|
      t.string :name
      t.string :description
      t.belongs_to :area, index: true

      t.timestamps null: false
    end
  end
end
