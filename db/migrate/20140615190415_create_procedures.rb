class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :folio
      t.date :donedate
      t.integer :minutes
      t.text :notes
      t.belongs_to :user, index: true
      t.belongs_to :surgery, index: true

      t.timestamps
    end
  end
end
