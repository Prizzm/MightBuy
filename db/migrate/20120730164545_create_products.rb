class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :url

      t.timestamps
    end
  end
end
