class AddShareTitleToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :share_title, :string
  end
end