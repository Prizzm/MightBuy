class SessionsController < Devise::SessionsController
  layout "welcomes"

  def create
    super()
    session_actions if current_user
  end

  private
  def session_actions
    response_id = session.delete(:response_id)
    if response_id && response = Response.find_by_id(response_id)
      response.update_attributes(user_id: current_user.id)
    end
  end
end
