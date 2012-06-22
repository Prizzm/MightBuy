class AddPriceToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :price, :integer
  end
end
