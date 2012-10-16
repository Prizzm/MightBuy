class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string

    User.reset_column_information
    User.find_each(&:save)
  end
end
