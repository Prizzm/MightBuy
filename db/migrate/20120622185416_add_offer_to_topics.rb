class AddOfferToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :offer, :integer
  end
end
