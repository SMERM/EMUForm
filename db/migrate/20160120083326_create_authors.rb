class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :first_name, :null => false
      t.string :last_name,  :null => false
      t.integer :birth_year, :size => 11
      t.text :bio_en
      t.text :bio_it

      t.timestamps null: false
    end
  end
end
