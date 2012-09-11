class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references  :topic, null: false
      t.references  :user,  null: false
      t.references  :parent
      t.text        :description, default: ""

      t.timestamps
    end
  end
end
