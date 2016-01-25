class CreateActiveAdminComments < ActiveRecord::Migration
  def change
    create_table :active_admin_comments do |t|
      t.string :resource_type, :null => false
      t.integer :resource_id, :null => false
      t.references :admin_account, :polymorphic => true
      t.string :namespace
      t.text :body

      t.index :resource_id
      t.index :resource_type
      t.index :admin_account_type
      t.index :admin_account_id

      t.timestamps null: false
    end
  end
end
