class CreateExamineds < ActiveRecord::Migration
  def change
    create_table :examineds do |t|
      t.integer :user_id, index: true
      t.integer :procedure_id, index: true
      t.timestamps
    end
  end
end
