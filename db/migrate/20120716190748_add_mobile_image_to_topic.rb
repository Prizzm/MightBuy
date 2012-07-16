class AddMobileImageToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :mobile_image_url, :string
  end
end
