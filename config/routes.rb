NewPrizzmCom::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # API
  namespace :api do
    namespace :v1  do
      resources :tokens,:only => [:create, :destroy]
      resources :topics, :controller=>:topics_api
      match "/user/info" => "users_api#info"
      match "/topics/create" => "topics#create"
    end
  end

  # Authentication
  devise_for :users, 
    :path_names => { 
      :sign_in => '/login', 
      :sign_out => '/logout', 
      :sign_up => '/join',  
    },
    :controllers => {
      :sessions     => "sessions",
      :registrations => "registrations"
    }
  
  devise_scope :user do
    get "login",   :to => "sessions#new"
    post "login",  :to => "sessions#create"
    get "logout",  :to => "sessions#destroy"
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
  #get 'me' => 'topics#index', :as => 'user_root'
  resource :profile, :controller => "profile"
  
  # Topics
  resources :topics do
    resources :responses
    get 'share' => 'topics#share'
    get 'thanks' => 'promotions#opinion'
    
    collection do
      get 'recommendation' => 'topics#new', :topic => { :form => :recommendation }
      get 'business/recommendation' => 'topics#new', :topic => { :form => :business_recommendation }
      get 'recommend' => 'topics#new', :topic => { :form => :recommend }
    end
  end
  
  get 'activity' => 'activity#index'
  
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
  get 'share/:shortcode' => "router#shared", :as => :shared
  get 'invited/:shortcode' => "router#invited", :as => :invited
  post 'register' => 'router#register', :as => :register
  post 'join_beta' => 'router#join_beta', :as => :join_beta
  
  # Uploads
  post 'uploads/accept' => 'upload#accept'

  
  # Website
  get 'about'   => 'website#about'
  get 'contact' => redirect('/about#contact')
  get 'privacy' => redirect('/about#privacy')
  
  # Sandbox
  get 'sandbox' => "website#sandbox"
  
  # Fragments
  get 'partial/:action' => 'fragments'
  
  # Brands / Shoppers
  get '/shoppers' => 'website#index', :shopper => true
  
  # Root
  root :to => "website#index"
  
end