class AddFulfilledToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :fulfilled, :boolean
  end
end
