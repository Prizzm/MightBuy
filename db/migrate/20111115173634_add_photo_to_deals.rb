class AddPhotoToDeals < ActiveRecord::Migration
  def change
    add_column :deal_deals, :photo, :string
  end
end