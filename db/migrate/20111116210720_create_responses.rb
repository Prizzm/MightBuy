class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.belongs_to :topic
      t.belongs_to :user
      t.text :body
      t.timestamps
    end
  end
end