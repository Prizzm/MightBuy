class AddRecommendationToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :recommendation, :string, default: "undecided"
  end
end
