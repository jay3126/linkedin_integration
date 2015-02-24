require 'will_paginate/array'

class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def check_user_session
		unless current_user.present?
			flash[:alert] = "Please login to continue."
			redirect_to root_path and return false
		end
	end
end