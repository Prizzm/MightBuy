class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.belongs_to :topic
      t.belongs_to :user
      t.string :with
      t.string :type
      t.timestamps
    end
  end
end
