class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title, :null=>false
      t.datetime :year, :null=>false
      t.datetime :duration, :null=>false
      t.string :instruments, :null=>false
      t.text :program_notes_en, :null=>false
      t.text :program_notes_it
      t.string :directory # TODO make it null: false when infrastructure is in place

      t.timestamps null: false
    end
  end
end
