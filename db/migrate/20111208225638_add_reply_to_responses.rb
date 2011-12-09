class AddReplyToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :reply_id, :integer
  end
end