#
# +AuthorsWorks+
#
# this is the switch table for the Author => Work many-to-many relationship
#
class AuthorsWorks < ActiveRecord::Migration
  def change
    create_table :authors_works, :id => false do |t|
      t.integer :author_id, :null => false
      t.integer :work_id, :null => false
    end
  end
end
