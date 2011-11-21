NewPrizzmCom::Application.routes.draw do

  # Authentication
  # devise_for :users
  devise_for :users, :path_names => { 
    :sign_in => '/login', 
    :sign_out => '/logout', 
    :sign_up => '/join'
  }
  
  devise_scope :user do
    get "login",   :to => "devise/sessions#new"
    post "login",  :to => "devise/sessions#create"
    get "logout",  :to => "devise/sessions#destroy"
    get "join",  :to => "devise/registrations#new"
    post "join", :to => "devise/registrations#create"
  end
  
  # Auth Roots
  get 'me' => 'profile#show', :as => 'user_root'
  resource :profile, :controller => "profile"
  
  # Topics
  resources :topics do
    resources :responses
    get 'share' => 'shares#new'
    resources :shares, :only => [:new, :create]
  end
  
  # Users
  resources :users, :only => [:index, :show]
  
  # Products
  resources :products do
    get 'feedback' => 'reviews#feedback'
    get 'feedback/thanks' => 'reviews#thanks'
    resources :reviews
  end
  
  # Sandbox
  get 'sandbox' => "website#sandbox"
  
  # Root
  root :to => "website#index"
  
end