class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.belongs_to :user
      t.string :shortcode
      t.string :image, :subject
      t.text :body
      t.string :access, :type
      t.timestamps
    end
    add_index :topics, :shortcode, :unique => true
  end
end