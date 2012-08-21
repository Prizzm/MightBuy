class CreateBusinessProducts < ActiveRecord::Migration
  def change
    create_table :business_products do |t|
      t.integer :business_id
      t.integer :product_id

      t.timestamps
    end
  end
end
