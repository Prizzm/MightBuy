class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :address_city
      t.string :address_country
      t.string :address_line1
      t.string :address_line1_check
      t.string :address_line2
      t.string :address_line2_check
      t.string :address_state
      t.string :address_zip
      t.string :address_zip_check
      t.string :country
      t.string :cvc_check
      t.string :exp_month
      t.integer :exp_year
      t.string :fingerprint
      t.string :last4
      t.string :name
      t.string :card_object
      t.string :card_type

      t.timestamps
    end
  end
end
