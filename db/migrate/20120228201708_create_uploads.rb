class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :image_uid
      t.timestamps
    end
  end
end
