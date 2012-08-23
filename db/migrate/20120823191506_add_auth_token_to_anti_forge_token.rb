class AddAuthTokenToAntiForgeToken < ActiveRecord::Migration
  def change
    add_column :anti_forge_tokens, :authorization_token, :string
  end
end
