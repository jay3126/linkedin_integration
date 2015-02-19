class CreateLinkedinProfiles < ActiveRecord::Migration
	def change
		create_table :linkedin_profiles do |t|
			t.integer :user_id
			t.integer :count
			t.integer :total_count
			t.integer :start

			t.timestamps
		end
	end
end