class AddOrderIdToCard < ActiveRecord::Migration
  def change
    add_column :cards, :order_id, :integer
  end
end
