class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references  :topic, null: false
      t.references  :user,  null: false
      t.boolean     :buyit, default: false

      t.timestamps
    end
  end
end
