class Users::MeController < Users::BaseController

  # Defaults
  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user'
  
  def resource
    current_user
  end
  
  def collection_path
    resource_path
  end
  
end