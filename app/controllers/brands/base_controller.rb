class Brands::BaseController < InheritedResources::Base

  # Filters
  before_filter :authenticate_brand!
  
end