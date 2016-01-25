#
# +AuthorsWorks+
#
# this is the switch table for the Author => Work many-to-many relationship
#
class CreateAuthorWorks < ActiveRecord::Migration
  def change
    create_table :author_works do |t|
      t.integer :author_id, :null => false
      t.integer :work_id, :null => false
    end
  end
end
