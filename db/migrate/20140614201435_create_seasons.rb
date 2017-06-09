class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.date :startdate
      t.date :enddate

      t.timestamps null: false
    end
  end
end
