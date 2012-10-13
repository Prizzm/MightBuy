NewPrizzmCom::Application.routes.draw do
  get "search/public"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # API
  namespace :api do
    namespace :v1  do
      resources :tokens,:only => [:create, :destroy]
      resources :topics, :controller=>:topics_api do
        get :trending, on: :collection
      end

      resources :comments
      get 'search', :to => "topics_api#search"
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
      :registrations => "registrations",
      :omniauth_callbacks => "omniauth_callbacks"
    }

  devise_scope :user do
    get "login",   :to => "sessions#new"
    post "login",  :to => "sessions#create"
    get "logout",  :to => "sessions#destroy"
    get "join",  :to => "registrations#new"
    post "join", :to => "registrations#create"
    get 'brands/join', :to => 'registrations#new', :brand => true
  end

  # Passbook
  match '/passbook/passes/generate' => "passbook#generate"
  match '/passbook/passes/:aftoken' => "passbook#pass"
  match "/passbook/passes/v1/devices/:devid/registrations/:bundleid/:serialnumber" => "passbook#register_device", :constraints => { :bundleid => /[^\/]+/ }
  match "/passbook/passes/v1/passes/:typeid/:serialnumber" => "passbook#get_current_pass", :constraints => { :typeid => /[^\/]+/ }

  # match "/tokens/facebook" => "social#authenticateMobile"
  match "/tokens/facebook" => "social#socialAuthenticationAPIFacebook"
  match "/tokens/twitter" => "social#socialAuthenticationAPITwitter"
  match "/topics/findByMIU" => "social#getShortCode"
  match "/social/mobile/askfriends" => "social#askMobileFriends"

  # Scraping
  post 'get/product' => 'get#product'
  post 'get/images_and_price' => 'get#images'

  # Auth Roots
  get 'welcome' => 'profile#welcome', :as => 'welcome'
  get 'me' => 'profile#show', :as => 'user_root'
  #get 'me' => 'topics#index', :as => 'user_root'
  resource :profile, :controller => "profile"
  resources :haves do
    member do
      get 'copy'
      put 'recommend'
    end
  end

  # Topics
  resources :topics do
    resources :votes, only: :create
    resources :comments, only: :create
    resources :email_shares, only: [:new, :create]

    resources :responses
    get 'login' => 'topics#login'
    get 'thanks' => 'promotions#opinion'

    collection do
      get 'recommendation' => 'topics#new', :topic => { :form => :recommendation }
      get 'business/recommendation' => 'topics#new', :topic => { :form => :business_recommendation }
      get 'recommend' => 'topics#new', :topic => { :form => :recommend }
    end

    member do
      get 'copy'
      put 'ihave'
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
  # Sharing
  match 'topics/:sc/social/ask/facebook' => 'social#facebook', as: :social_ask_facebook
  match 'topics/:sc/social/ask/twitter' => 'social#twitter',   as: :social_ask_twitter
  match 'topics/:sc/social/ask/all' => 'social#askAll'
  # Authentication
  match 'users/auth/methods/facebook/uid' => 'social#socialAuthenticationAPI'

  # Linking
  match 'profile/unlink/facebook' => 'social#unlinkFacebookAccount'
  match 'profile/unlink/twitter' => 'social#unlinkTwitterAccount'

  # Router
  get 'share/:shortcode' => "router#shared", :as => :shared
  get 'invited/:shortcode' => "router#invited", :as => :invited
  post 'register' => 'router#register', :as => :register
  post 'join_beta' => 'router#join_beta', :as => :join_beta

  # Uploads
  post 'uploads/accept' => 'upload#accept'


  # Sandbox
  get 'sandbox' => "website#sandbox"

  # Fragments
  get 'partial/:action' => 'fragments'

  # Brands / Shoppers
  get '/shoppers' => 'website#index', :shopper => true

  # Search
  get "/search", :to => "search#public"

  resources :welcomes, only: :index
  resources :tags, :only => :index do
    member do
      get :topics
    end
    collection do
      post :update_tags
    end
  end

  # in config/routes.rb
  match "/pages/*id" => 'pages#show', :as => :page, :format => false

  # Root
  root :to => "welcomes#index"
end
