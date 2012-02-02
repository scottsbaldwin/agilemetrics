class AddRememberTokenToUsers < ActiveRecord::Migration
  def up
	add_column :users, :remember_token, :string
  end

  def down
	remove_column :users, :remember_token
  end
end
