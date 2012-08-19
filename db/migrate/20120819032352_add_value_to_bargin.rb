class AddValueToBargin < ActiveRecord::Migration
  def change
    add_column :bargins, :value, :string
    add_column :bargins, :application, :string
    add_column :bargins, :bargin_type, :string
  end
end
