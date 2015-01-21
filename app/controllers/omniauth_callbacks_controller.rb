class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
	def linkedin
		auth = env["omniauth.auth"]
		@user = User.connect_to_linkedin(request.env["omniauth.auth"],current_user)
		if @user.persisted?
			flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
			sign_in_and_redirect @user, :event => :authentication
		else
			session["devise.linkedin_uid"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end

	def fetch_profiles
		client = LinkedIn::Client.new(your_consumer_key, your_consumer_secret)
		request_token = client.request_token({})
		rtoken = request_token.token
		rsecret = request_token.secret
		request_token.authorize_url
		pin = 12694
		client.authorize_from_request(rtoken, rsecret, pin)
		linkedin_requests = client.authorize_from_request(rtoken, rsecret, pin)
		linkedin_requests = ["aad07521-4220-4083-bda2-0182924969cf", "288e8fe8-ec2a-4cf8-b1a9-b1d497aaf81f"]
		client.profile
		client.connections
		client.connections.keys
		client.connections.values
		client.connections.values[3]
		my_connections = client.connections.values[3]
		my_connections.last.values
		my_connections.first.values
	end
end