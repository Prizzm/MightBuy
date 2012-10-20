class AddAcceptPaymentsToBargin < ActiveRecord::Migration
  def change
    add_column :bargins, :accept_payments, :boolean
  end
end
