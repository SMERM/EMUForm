class CreateRoles < ActiveRecord::Migration

  def change
    create_table :roles do |t|
      t.boolean :static, null: false, default: false
      t.string :description, null: false, unique: true
      t.index :description

      t.timestamps null: false
    end
  end

end
