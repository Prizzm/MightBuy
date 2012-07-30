class Changecolumnproductidforbargins < ActiveRecord::Migration
  def up
     change_table :bargins do |t|
            t.change :product_id, :integer
          end
  end

  def down
  end
end
