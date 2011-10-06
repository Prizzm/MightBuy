# Sources
source 'http://rubygems.org'

# Rails
gem 'rails', '3.1.0'
gem 'jquery-rails'

# Authentication
gem 'devise', '1.4.7'

# Layout
gem 'slim-rails', '0.2.1'
gem 'inherited_resources', '1.3.0'
gem 'simple_form', '1.5.2'
gem 'premailer-rails3', '1.0.0'
gem 'nokogiri', '1.5.0'
gem 'meta-tags', '1.2.4', :require => 'meta_tags'
gem 'kaminari', '0.12.4'

# Uploads
gem 'mini_magick'
gem 'carrierwave', '0.5.7'

# Assets
gem "compass", "0.12.alpha.0"

# AWS
gem 'fog', '1.0.0'

# Assets
gem 'sass-rails', "3.1.4"

# Server
gem 'thin', '1.2.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :development do
  # gem 'unicorn'
  gem 'sqlite3'
  gem 'rb-fsevent'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'rails-dev-tweaks', '~> 0.5.1'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'pg', '0.11.0'
end