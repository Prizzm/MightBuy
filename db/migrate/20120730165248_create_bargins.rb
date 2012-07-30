class CreateBargins < ActiveRecord::Migration
  def change
    create_table :bargins do |t|
      t.string :name
      t.string :offer
      t.string :type
      t.text :description
      t.string :url
      t.integer :product_id

      t.timestamps
    end
  end
end
