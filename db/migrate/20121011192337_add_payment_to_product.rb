class AddPaymentToProduct < ActiveRecord::Migration
  def change
    add_column :products, :accept_payments, :integer
  end
end
