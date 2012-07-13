class AddShortcodeToShares < ActiveRecord::Migration
  def change
    add_column :shares, :shortcode, :string
    add_index :shares, :shortcode, :unique => true
  end
end