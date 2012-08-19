class AddRecommendedTypeToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :recommend_type, :string
  end
end