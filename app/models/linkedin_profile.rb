class LinkedinProfile < ActiveRecord::Base
	belongs_to :user
	has_many :linkedin_connections
end