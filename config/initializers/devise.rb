Devise.setup do |config|
	require 'devise/orm/active_record'
	require 'omniauth-linkedin'
	config.omniauth :linkedin, "78dtq60tch3i8c", "h6ku1JYIU5KA0UpR"
end