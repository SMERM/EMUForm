r.equire 'EMUForm/role_manager'

class CreateRoles < ActiveRecord::Migration
  def migrate(direction)
    super
    case direction
    when :up then EMUForm::RoleManager.setup
    when :down then EMUForm::RoleManager.clear
    end
  end

  def change
    create_table :roles do |t|
      t.boolean :static, null: false, default: false
      t.string :description, null: false, unique: true
      t.index :description

      t.timestamps null: false
    end
  end
end
