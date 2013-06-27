class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string  :password_salt
      t.string  :password_hash
      t.timestamps
    end
  end
end
