class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :description, null: false, unique: true

      t.timestamps null: false
    end
  end
end
