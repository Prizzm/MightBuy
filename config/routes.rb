NewPrizzmCom::Application.routes.draw do

  # Authentication
  devise_for :users, 
    :path_names => { 
      :sign_in => '/login', 
      :sign_out => '/logout', 
      :sign_up => '/join'
    },
    :controllers => {
      :registrations => "registrations"
    }
  
  devise_scope :user do
    get "login",   :to => "devise/sessions#new"
    post "login",  :to => "devise/sessions#create"
    get "logout",  :to => "devise/sessions#destroy"
    get "join",  :to => "registrations#new"
    post "join", :to => "registrations#create"
    get 'brands/join', :to => 'registrations#new', :brand => true
  end
  
  # Scraping
  post 'get/product' => 'get#product'
  post 'get/images' => 'get#images'
  
  # Auth Roots
  get 'welcome' => 'profile#welcome', :as => 'welcome'
  get 'me' => 'profile#show', :as => 'user_root'
  resource :profile, :controller => "profile"
  
  # Topics
  resources :topics do
    resources :responses
    get 'share' => 'shares#new'
    get 'thanks' => 'promotions#opinion'
    
    resources :shares, :only => [:new, :create]
    
    collection do
      get 'recommendation' => 'topics#new', :topic => { :form => :recommendation }
      get 'recommend' => 'topics#new', :topic => { :form => :recommend }
    end
  end
  
  # Users
  resources :users, :only => [:index, :show]
  resources :brands, :only => [:index, :show]
  
  # Products
  resources :products do
    get 'feedback' => 'reviews#feedback'
    get 'feedback/thanks' => 'reviews#thanks'
    resources :reviews
  end
  
  # Social
  post 'social/tweeted' => 'social#tweeted'
  post 'social/recommended' => 'social#recommended'
  
  # Router
  get 'invited/:shortcode' => "router#invited", :as => :invited
  
  # Sandbox
  get 'sandbox' => "website#sandbox"
  
  # Root
  root :to => "website#index"
  
end