class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
				 :recoverable, :rememberable, :trackable, :validatable, :omniauthable

	def self.connect_to_linkedin(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		if user
			return user
		else
			registered_user = User.where(:email => auth.info.email).first
			if registered_user
				return registered_user
			else

				user = User.create(name:auth.info.first_name,
														provider:auth.provider,
														uid:auth.uid,
														email:auth.info.email,
														password:Devise.friendly_token[0,20],
													)
			end
		end
	end

	def self.fetch_connections
		# https://github.com/hexgnu/linkedin/blob/master/EXAMPLES.md
		consumer_key = "78dtq60tch3i8c"
		consumer_secret = "h6ku1JYIU5KA0UpR"
		pin = 12694

		linkedin_configuration = {:site => 'https://api.linkedin.com',
															:authorize_path => '/uas/oauth/authenticate',
															:request_token_path =>'/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile+r_emailaddress+r_network+r_contactinfo+rw_groups+rw_nus',
															:access_token_path => '/uas/oauth/accessToken' }
		client = LinkedIn::Client.new(consumer_key, consumer_secret, linkedin_configuration)
		request_token = client.request_token({}, :scope => "r_basicprofile r_fullprofile r_emailaddress r_network r_contactinfo rw_groups rw_nus")
		rtoken = request_token.token
		rsecret = request_token.secret
		request_token.authorize_url
		pin = 12694
		# client.authorize_from_request(rtoken, rsecret, pin)
		# linkedin_requests = client.authorize_from_request(rtoken, rsecret, pin)
		linkedin_requests = ["aad07521-4220-4083-bda2-0182924969cf", "288e8fe8-ec2a-4cf8-b1a9-b1d497aaf81f"]
		# authorize from previously fetched access keys
		client.authorize_from_access(linkedin_requests[0], linkedin_requests[1])
		client.profile
		client.connections
		client.connections.keys
		client.connections.values
		client.connections.values[3]
		my_connections = client.connections.values[3]
		# my_connections.last.values
		# my_connections.first.values
	end
end