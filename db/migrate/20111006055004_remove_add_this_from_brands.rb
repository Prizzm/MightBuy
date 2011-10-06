class RemoveAddThisFromBrands < ActiveRecord::Migration
  def change
    remove_column :brands, :social_addthis_code
  end
end