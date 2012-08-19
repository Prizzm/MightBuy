class AddFormToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :form, :string
  end
end