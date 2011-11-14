class DeviseCreateBrands < ActiveRecord::Migration
  
  def change
    create_table(:brands) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.string :name, :logo
      t.text :description
      
      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
      
      t.timestamps
    end
    
    add_index :brands, :email,                :unique => true
    add_index :brands, :reset_password_token, :unique => true
  end
  
end