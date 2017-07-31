class CreateManagements < ActiveRecord::Migration
  def change
    create_table :managements do |t|
      t.integer :manager_id, index: true, foreign_key: true
      t.belongs_to :area, index: true, foreign_key: true

      t.timestamps null: false
    end
    Area.find_each do |area|
      area.manager = User.find(area.user_id)
      area.save!
    end
  end
end
