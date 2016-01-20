class CreateSubmittedFiles < ActiveRecord::Migration
  def change
    create_table :submitted_files do |t|
      t.string :filename, :null => false
      t.string :content_type, :null => false
      t.integer :size, :null => false
      t.integer :work_id, :null => false

      t.timestamps null: false
    end
  end
end
