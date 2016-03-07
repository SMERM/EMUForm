class CreateWorkRoleAuthorJoinTable < ActiveRecord::Migration
  def change
    create_table :works_roles_authors, id: false do |t|
      t.references :work
      t.references :role
      t.references :author
      t.index [:work_id, :role_id, :author_id], unique: true
    end
  end
end
