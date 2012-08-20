class AddUrlToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :url, :string
  end
end