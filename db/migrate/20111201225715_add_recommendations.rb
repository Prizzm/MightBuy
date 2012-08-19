class AddRecommendations < ActiveRecord::Migration
  def change
    add_column :topics, :recommendable, :boolean, :default => false
    add_column :responses, :recommended, :boolean
  end
end