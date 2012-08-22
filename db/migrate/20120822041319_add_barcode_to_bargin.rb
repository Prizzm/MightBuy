class AddBarcodeToBargin < ActiveRecord::Migration
  def change
    add_column :bargins, :barcode, :string
  end
end
