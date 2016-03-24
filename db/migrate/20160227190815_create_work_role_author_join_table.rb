class CreateWorkRoleAuthorJoinTable < ActiveRecord::Migration
  def change
    create_table :works_roles_authors, id: false do |t|
      t.references :work,       null: false
      t.references :role,       null: false
      t.references :author,     null: false
      t.references :edition
      t.index [:work_id, :role_id, :author_id, :edition_id], unique: true, name: 'wrae_index'
    end
  end
end
