class AddEmailToUsers < ActiveRecord::Migration

	def self.up
		add_column :users, :email, :string
		add_index :users, :email, :unique => true
	end

	def self.down
		remove_column :users, :email
	end

end
