class CreateAuthorWorkRole < ActiveRecord::Migration
  def change
    create_table :author_work_roles, :id=>false do |t|
      t.integer :author_work_id
      t.integer :role_id
    end
  end
end
