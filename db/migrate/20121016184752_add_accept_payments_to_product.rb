class AddAcceptPaymentsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :accept_payments, :boolean
  end
end
