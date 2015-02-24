include ApplicationHelper

class LinkedinDatatable

	delegate :params, :link_to, to: :@view

	def initialize(view, total_count, current_user)
		@view = view
		@TotalRows = total_count
		@current_user = current_user
	end

	def as_json(options = {})
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: @TotalRows,
			aaData: data,
			iTotalDisplayRecords: @TotalRows,
		}
	end

	private
	def data
		count = 0
		connections.map do |mc|
			img = "<img src=\"#{mc.profile_pic_url}\">"
			[
				count += 1,
				img,
				(mc.first_name),
				(mc.last_name),
				(mc.linkedin_id),
				(mc.location_name),
				(mc.industry)
			]
		end
	end

	def connections
		@connections ||= fetch_products
	end

	def fetch_products
		connections = LinkedinConnection.fetch_my_connections(page, per_page, @current_user)
		@TotalRows = connections[0]
		connections[1]
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 1
	end

end