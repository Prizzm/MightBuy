class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :topic_id
      t.string :invoice_id
      t.float :amount
      t.float :amount_refunded
      t.integer :created_stripe
      t.string :currency
      t.string :customer
      t.string :description
      t.boolean :disputed
      t.string :failure_message
      t.float :fee
      t.string :invoice
      t.boolean :livemode
      t.string :object
      t.string :paid
      t.boolean :refunded
      t.integer :card_id
      t.integer :fee_id

      t.timestamps
    end
  end
end
