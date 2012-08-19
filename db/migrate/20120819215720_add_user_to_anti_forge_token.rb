class AddUserToAntiForgeToken < ActiveRecord::Migration
  def change
    add_column :anti_forge_tokens, :user_id, :integer
  end
end
