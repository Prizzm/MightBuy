# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require "pry"
require 'rspec/rails'
require 'rspec/autorun'
require "vcr"

OmniAuth.config.test_mode = true
FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__),"..","vendor/mightbuy-models/spec/factories")
FactoryGirl.find_definitions


Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  config.include OAuthSpecHelper
  config.include TopicSpecHelper
  config.extend VCR::RSpec::Macros
  config.include Devise::TestHelpers, :type => :controller

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

VCR.configure do |c|
  c.default_cassette_options = {:record => :new_episodes, :erb => true}
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = File.join(File.dirname(__FILE__), "fixtures/vcr_cassettes")
  c.hook_into :webmock
end
