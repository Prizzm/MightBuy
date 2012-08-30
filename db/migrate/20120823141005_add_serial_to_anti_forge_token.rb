class AddSerialToAntiForgeToken < ActiveRecord::Migration
  def change
    add_column :anti_forge_tokens, :serial_number, :string
    add_column :anti_forge_tokens, :device_id, :string
  end
end
