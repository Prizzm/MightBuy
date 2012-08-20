class AddOauthToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_oauth_token, :string
    add_column :users, :facebook_oauth_secret, :string
    add_column :users, :twitter_oauth_token, :string
    add_column :users, :twitter_oauth_secret, :string
  end
end
