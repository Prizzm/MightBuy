class Brands::MeController < Brands::BaseController

  # Defaults
  defaults :resource_class => Brand, :collection_name => 'brands', :instance_name => 'brand'
  
  
  def resource
    current_brand
  end
  
  def collection_path
    resource_path
  end
  
end