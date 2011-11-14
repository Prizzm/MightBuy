class Users::BaseController < InheritedResources::Base

  # Filters
  before_filter :authenticate_user!
  
end