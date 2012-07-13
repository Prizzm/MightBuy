class AddVisitorTracking < ActiveRecord::Migration
  
  def change
    add_column :responses, :visitor_code, :string, :length => 50
    add_column :shares, :visitor_code, :string, :length => 50
  end
  
end