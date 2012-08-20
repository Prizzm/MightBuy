class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :latitude
      t.string :longitude
      t.string :foreground
      t.string :background

      t.timestamps
    end
  end
end
