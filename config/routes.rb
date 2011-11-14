NewPrizzmCom::Application.routes.draw do

  # Authentication
  devise_for :users, :path_names => { 
    :sign_in => 'login', 
    :sign_out => 'logout', 
    :sign_up => 'join'
  }
  
  devise_for :brands, :path_names => { 
    :sign_in => 'login', 
    :sign_out => 'logout', 
    :sign_up => 'join'
  }
  
  # Auth Roots
  get 'users/me' => 'users/me#show', :as => 'user_root'
  get 'brands/me' => 'brands/me#show', :as => 'brand_root'
  
  # Users
  namespace :users do
    resource :me, :controller => "me"
  end
  
  # Brands
  namespace :brands do
    resource :me, :controller => "me"
    resources :products
    resources :reviews
    resources :invites
  end
  
  # Brands
  resources :brands
  
  # Products
  resources :products do
    get 'feedback' => 'reviews#feedback'
    get 'feedback/thanks' => 'reviews#thanks'
    resources :reviews
  end
  
  # Router
  get 'invited/:invite_code' => 'router#invite', :as => :invited
  post 'beta/join.js' => 'router#join', :as => :beta_join
  
  # Sandbox
  get 'sandbox' => "website#sandbox"
  
  # Root
  root :to => "website#index"
  
end