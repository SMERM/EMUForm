class CreateAuthorWorkRoles < ActiveRecord::Migration
  def change
    create_table :author_work_roles do |t|
      t.integer :author_id, null: false
      t.integer :work_id,   null: false
      t.integer :role_id,   null: false

      t.timestamps null: false
    end
  end
end
