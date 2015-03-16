Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'passwordreset/new'

  get 'passwordreset/edit'

  root   'static_pages#home'
  #get   'static_pages/home'
  get    'help'      => 'static_pages#help'
  get    'about'     => 'static_pages#about'
  get    'contact'   => 'static_pages#contact'
  
  get    'signup'    => 'users#new'
  
  get    'login'     => 'sessions#new'
  post   'login'     => 'sessions#create'
  delete 'logout'    => 'sessions#destroy'
  # resourcs dodaje możliwość korzystania z wszystkich REST akcji
  resources :users do
  	#Dodaje linki do user_path, tworząc linki: /users/1/followers lub 
  	#	/users/1/following, nazwy to: followers_user_path i following_user_path
  	member do
  		# 'get' jest wskazaniem typu żadania danego linku
  		get :following, :followers
  	end
  end
  # ograniczenie przekierowań tylko do akcji edit.
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

end
