class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      # database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      # recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # rememberable
      t.datetime :remember_created_at

      # trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end

end
