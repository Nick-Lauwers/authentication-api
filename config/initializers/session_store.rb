if Rails.env == 'production'
	Rails.application.config.session_store :cookie_store, 
																			 	 key: '_website-builder', 
																			 	 domain: 'website-builder.com'

else
	Rails.application.config.session_store :cookie_store, key: '_website-builder'
end