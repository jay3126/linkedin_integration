# http://sreeharikmarar.blogspot.in/2013/08/linkedin-gem-with-rails-4-how-to-import.html
# https://developer.linkedin.com/documents/profile-fields
# http://zapone.org/blaine/2015/01/04/rails-linkedin-gem-not-able-to-fetch-connectionss-email-ids/

class LinkedinController < ApplicationController

	before_filter :check_user_session, only: [:my_connections]

	def init_client
		key = Constants::LINKEDIN_APP_ID
		secret = Constants::LINKEDIN_APP_KEY
		linkedin_configuration = { :site => 'https://api.linkedin.com',
				:authorize_path => '/uas/oauth/authenticate',
				:request_token_path =>'/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile+r_emailaddress+r_network+r_contactinfo+rw_groups+rw_nus',
				:access_token_path => '/uas/oauth/accessToken' }
		@linkedin_client = LinkedIn::Client.new(key, secret,linkedin_configuration )
	end

	def auth
		init_client
		request_token = @linkedin_client.request_token(:oauth_callback => "http://#{request.host_with_port}/linkedin/callback")
		session[:rtoken] = request_token.token
		session[:rsecret] = request_token.secret
		redirect_to @linkedin_client.request_token.authorize_url
	end

	def callback
		init_client
		if session[:atoken].nil?
			pin = params[:oauth_verifier]
			atoken, asecret =  @linkedin_client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
			session[:atoken] = atoken
			session[:asecret] = asecret
		else
			@linkedin_client.authorize_from_access(session[:atoken], session[:asecret])
		end

		c = @linkedin_client

		# fetching basic profile
		# profile_1 = c.profile(:fields=>["first_name","last_name","headline","public_profile_url","date-of-birth","main_address","phone-numbers","primary-twitter-account","twitter-accounts","location"])
		@basic_profile = c.profile(:fields=>["id","first-name","last-name","maiden-name","formatted-name","phonetic-first-name","phonetic-last-name","formatted-phonetic-name","headline","industry","distance","current-share","num-connections","num-connections-capped","summary","specialties","positions","picture-url","site-standard-profile-request","public-profile-url"])
		# data[:basic_profile] = @basic_profile

		#fetching email address.
		@profile_email_address = c.profile(:fields=>["email-address"])

		#fetching full profile.
		@full_profile = c.profile(:fields=>["last-modified-timestamp","proposal-comments","associations","interests","publications","patents","languages","skills","certifications","educations","courses","volunteer","three-current-positions","three-past-positions","num-recommenders","recommendations-received","following","job-bookmarks","suggestions","date-of-birth","member-url-resources","related-profile-views","honors-awards"])

		#fetching contact info
		@contact_info = c.profile(:fields=>["phone-numbers","bound-account-types","im-accounts","main-address","twitter-accounts","primary-twitter-account"])

		#fetching connections
		@connections = c.connections
		@my_connections = @connections["all"]
		lp = LinkedinProfile.find_or_initialize_by(user_id: current_user.id)
		lp.update_attributes(count: @connections["_count"], total_count: @connections["total"], start: @connections["_start"])

		LinkedinConnection.insert_connections(@my_connections, lp, current_user)

		#fetching group memberships
		@grp_memberships = c.profile(:fields=>["group-memberships"])

		#fetching network details
		@ntw_details = c.profile(:fields=>["network"])

		profile_2 = c.profile(:fields=>["positions","three_current_positions","three_past_positions","publications","patents"])
		profile_3 = c.profile(:fields=>["languages","skills","certifications","educations"])
		
		session[:atoken] = nil
		session[:asecret] = nil
		redirect_to my_connections_path
	end

	def my_connections
		@profile_count = LinkedinProfile.find_by(user_id: current_user.id)
		@connections = {}
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: LinkedinDatatable.new(view_context, @profile_count.total_count, current_user) }
		end

		# if current_user.present?
		# 	@profile_count = LinkedinProfile.find_by(user_id: current_user.id)
		# 	@my_connections = LinkedinConnection.where(user_id: current_user.id).to_a.paginate(page: params[:page], per_page: params[:per_page])
		# else
		# 	@profile_count = ""
		# 	@my_connections = []
		# end
	end

end