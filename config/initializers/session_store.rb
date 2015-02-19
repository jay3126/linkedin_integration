# Be sure to restart your server when you modify this file.

LinkedinIntegrationWithRails::Application.config.session_store :cookie_store, key: '_linkedin_integration_with_rails_session',
	httponly: true, # Disable cookie read by javascript
	expire_after: 15.minutes