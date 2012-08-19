class AddPassPathToAntiForgeToken < ActiveRecord::Migration
  def change
    add_column :anti_forge_tokens, :pass_path, :string
  end
end
