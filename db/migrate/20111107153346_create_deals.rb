class CreateDeals < ActiveRecord::Migration
  
  def change
    create_table :deal_deals, :force => true do |t|
      t.belongs_to :user
      t.belongs_to :for, :polymorphic => true
      t.string :title
      t.text :description
      t.integer :low_cost, :high_cost
      t.decimal :low_value, :high_value, :precision => 8, :scale => 2
      t.string :value_type
      t.timestamps
    end
    
    create_table :deal_redemptions, :force => true do |t|
      t.belongs_to :deal
      t.belongs_to :bank
      t.integer :cost
      t.decimal :value, :precision => 8, :scale => 2
      t.timestamps
    end
  end
  
end