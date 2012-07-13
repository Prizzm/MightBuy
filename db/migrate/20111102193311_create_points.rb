class CreatePoints < ActiveRecord::Migration
  
  def change
    create_table :point_banks do |t|  
      t.belongs_to :bankable, :polymorphic => true
      t.integer :total, :default => 0
      t.integer :available, :default => 0
      t.timestamps
    end
    
    create_table :point_allocations do |t|  
      t.belongs_to :bank
      t.belongs_to :allocatable, :polymorphic => true
      t.string :allocator
      t.integer :points, :default => 0
      t.string :lookup, :limit => 40
      t.timestamps
    end
    
    add_index :point_allocations, :lookup, :unique => true, :length => 40
  end
  
end