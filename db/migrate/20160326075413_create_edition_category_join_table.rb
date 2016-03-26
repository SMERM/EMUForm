class CreateEditionCategoryJoinTable < ActiveRecord::Migration
  def change
    create_join_table :editions, :categories do |t|
      t.index :edition_id
      t.index :category_id
    end
  end
end
