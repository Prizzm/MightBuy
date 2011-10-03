class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|  
      t.belongs_to :inviter, :polymorphic => true
      t.belongs_to :invitee, :polymorphic => true
      t.belongs_to :reference, :polymorphic => true
      t.string :code
      t.string :type
      t.datetime :visited_at
      t.timestamps
    end
  end
end
