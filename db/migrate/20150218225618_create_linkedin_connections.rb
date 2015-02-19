class CreateLinkedinConnections < ActiveRecord::Migration
	def change
		create_table :linkedin_connections do |t|
			t.string :standard_api_profile_request
			t.string :first_name
			t.string :last_name
			t.string :linkedin_id
			t.string :industry
			t.string :location_name
			t.string :location_code
			t.string :profile_pic_url
			t.string :standard_profile_request_url
			t.integer :linkedin_profile_id
			t.integer :user_id

			t.timestamps
		end
	end
end