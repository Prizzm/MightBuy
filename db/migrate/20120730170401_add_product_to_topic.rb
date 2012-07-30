class AddProductToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :product_id, :integer
  end
end
