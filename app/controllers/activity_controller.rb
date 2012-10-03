class ActivityController < RestfulController
  # Defaults
  defaults :resource_class => Response, :collection_name => 'responses', :instance_name => 'response'

  def collection
    current_user.topic_responses.order('created_at desc')
  end

  def resource
    nil
  end

end

