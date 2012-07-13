class AddRegisteredToShares < ActiveRecord::Migration
  def change
    add_column :shares, :registered, :boolean, :default => false
  end
end