class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :acro,          null: false, uniq: true, limit: 4
      t.string :title_en,      null: false
      t.string :title_it,      null: false
      t.text :description_en,  null: false
      t.text :description_it,  null: false

      t.timestamps             null: false
    end
  end
end
