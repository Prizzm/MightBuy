class ActivityController < RestfulController
  
  # Defaults
  defaults :resource_class => Response, :collection_name => 'responses', :instance_name => 'response'
  
  def collection
    end_of_association_chain.where(:user_id => params[:user])
  end
  
  def resource
    nil
  end
  
end