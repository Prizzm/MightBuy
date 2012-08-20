class CreateAntiForgeTokens < ActiveRecord::Migration
  def change
    create_table :anti_forge_tokens do |t|
      t.string :value
      t.date :date_created
      t.boolean :active
      t.integer :product_id
      t.integer :bargin_id

      t.timestamps
    end
  end
end
