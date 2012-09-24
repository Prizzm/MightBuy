class CreateTopicTags < ActiveRecord::Migration
  def change
    create_table :topic_tags do |t|
      t.integer :tag_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
