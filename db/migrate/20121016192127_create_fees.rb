class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.string :fee_type
      t.string :application
      t.string :currency
      t.integer :amount
      t.string :description

      t.timestamps
    end
  end
end
