class ChangeDataTypeForTopicPrice < ActiveRecord::Migration
  def up
    change_table :topics do |t|
          t.change :price, :float
        end
  end

  def down
    change_table :topics do |t|
          t.change :price, :integer
    end
  end
end
