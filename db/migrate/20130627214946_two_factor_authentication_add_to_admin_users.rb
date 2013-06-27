class TwoFactorAuthenticationAddToAdminUsers < ActiveRecord::Migration
  def change
    change_table :admin_users do |t|
      t.string   :second_factor_pass_code     , :limit => 32
      t.integer  :second_factor_attempts_count, :default => 0
    end
  end
end
