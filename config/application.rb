require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module NewPrizzmCom
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(lib).map {|path| Rails.root + path }

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    #config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :user_observer, :topic_observer, :response_observer, :share_observer

    config.active_support.escape_html_entities_in_json = true
    config.action_controller.include_all_helpers = false
    config.assets.precompile += ['new.js', 'new.css', 'website.js', 'website.css']

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Don't access the DB or load models when precompiling your assets.
    config.assets.initialize_on_precompile = false

    # Dragonfly middleware.
    config.middleware.insert 1, 'Dragonfly::Middleware', :images
  end
end

# load configatron here!
require "mightbuy/config"
Mightbuy.load_config

