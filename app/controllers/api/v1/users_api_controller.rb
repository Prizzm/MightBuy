class Api::V1::UsersApiController < Api::V1::ApiController
  def info
    @user = current_user
  end
end
