class AddBusinessToProduct < ActiveRecord::Migration
  def change
    add_column :products, :business_id, :integer
  end
end
