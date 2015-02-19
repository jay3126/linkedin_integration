class LinkedinConnection < ActiveRecord::Base

	belongs_to :linkedin_profile

	def self.insert_connections(data, linkedin_profile, user)
		begin
			Thread.new do
				data.each do |x|
					api_url = (x.api_standard_profile_request.present? && x.api_standard_profile_request.url.present?) ? x.api_standard_profile_request.url : "NA"
					location_name = (x.location.present? && x.location.name.present?) ? x.location.name : "NA"
					location_code = (x.location.present? && x.location.country.present? && x.location.country.code.present?) ? x.location.country.code : "NA"
					lc = LinkedinConnection.find_or_initialize_by(linkedin_id: x.id)
					lc.update_attributes(standard_api_profile_request: api_url, first_name: x.first_name, last_name: x.last_name,
															industry: x.industry, location_name: location_name, location_code: location_code, profile_pic_url: x.picture_url,
															standard_profile_request_url: x.site_standard_profile_request, user_id: user.id, linkedin_profile_id: linkedin_profile.id)
				end
			end
		rescue Exception => e
			puts e.message
		end
	end
end