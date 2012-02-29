class AddDragonflyToModels < ActiveRecord::Migration
  def change
    add_column :topics, :image_uid, :string
    add_column :responses, :image_uid, :string
    add_column :users, :image_uid, :string
  end
end