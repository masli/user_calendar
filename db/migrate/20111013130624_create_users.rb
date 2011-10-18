class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :namee
      t.string :encrypted_password
      t.string :salt
      t.boolean :admin ,:default => false

      t.timestamps
     
    end
    
  end
end
