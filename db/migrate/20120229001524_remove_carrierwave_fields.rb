class RemoveCarrierwaveFields < ActiveRecord::Migration
  def change
    remove_column :responses, :image
    remove_column :topics, :image
    remove_column :users, :photo
  end
end
