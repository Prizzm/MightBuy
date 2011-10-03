class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :brand
      t.string :name, :image
      t.timestamps
    end
  end
end
