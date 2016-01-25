class CreateAccounts < ActiveRecord::Migration

  def change
    change_table(:accounts)
  end

  #
  # this is used also by +AdminAccount+ so it is factored out
  #
  def change_table(table)
    create_table table do |t|
      t.string :login_name, :unique => true
      t.string :first_name
      t.string :last_name
      t.text :about
      t.string :image
      t.string :location

      # Devise stuff
      ## Database authenticatable
      t.string :email, :default => "", :unique => true
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Token authenticatable
      t.string :authentication_token

      t.timestamps null: false

      t.index :email, :unique => true
      t.index :reset_password_token, :unique => true
      t.index :confirmation_token, :unique => true
      t.index :authentication_token, :unique => true
    end
  end
end
