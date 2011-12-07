class AddShareToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :share_id, :integer
  end
end