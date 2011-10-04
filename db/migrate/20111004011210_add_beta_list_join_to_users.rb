class AddBetaListJoinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :on_invite_list, :boolean
  end
end