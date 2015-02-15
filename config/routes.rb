Rails.application.routes.draw do
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
  resources :users 
  # ograniczenie przekierowań tylko do akcji edit.
  resources :account_activations, only: [:edit]

end
