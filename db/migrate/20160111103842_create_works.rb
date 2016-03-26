class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.integer :owner_id, :null => false
      t.string :title, :null=>false
      t.datetime :year, :null=>false
      t.datetime :duration, :null=>false
      t.string :instruments, :null=>false
      t.text :program_notes_en, :null=>false
      t.text :program_notes_it
      t.string :directory,      :null => false
      t.integer :edition_id
      t.integer :category_id,   :null => false

      t.timestamps null: false
    end
  end
end
