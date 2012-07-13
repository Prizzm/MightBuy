class AddExtraFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :url, :string
    add_column :users, :description, :text
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :phone, :string
    add_column :users, :email_address, :string
    add_column :users, :category, :string, :default => "person"
  end
end