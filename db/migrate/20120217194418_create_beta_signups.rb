class CreateBetaSignups < ActiveRecord::Migration
  def change
    create_table :beta_signups do |t|
      t.string :email_address
      t.string :visitor_code, :length => 50
      t.timestamps
    end
  end
end