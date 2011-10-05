class AddSocialAttributesToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :social_url, :string
    add_column :brands, :social_title, :string
    add_column :brands, :social_desc, :string
    add_column :brands, :social_addthis_code, :text
  end
end