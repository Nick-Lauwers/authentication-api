Rails.application.routes.draw do
	
	get 	 'logged-in' => 'sessions#is_logged_in?'
	post 	 'login' 		 => 'sessions#create'
	delete 'logout' 	 => 'sessions#destroy'

	put 'forgot-password' => 'password_resets#forgot'
	put 'reset-password'  => 'password_resets#reset'

	resources :users, 					only: [:create, :show]
end