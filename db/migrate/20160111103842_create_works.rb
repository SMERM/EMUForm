class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title, :null=>false
      t.datetime :year
      t.datetime :duration
      t.string :instruments
      t.text :program_notes_en
      t.text :program_notes_it

      t.timestamps null: false
    end
  end
end
