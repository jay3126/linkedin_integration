module ApplicationHelper

	def flash_class(level,value)
		case level
		when :notice then "alert alert-info"
		when :success then "alert alert-success"
		when :alert then "alert alert-info"
		when :error then "alert alert-danger"
		end
	end
end