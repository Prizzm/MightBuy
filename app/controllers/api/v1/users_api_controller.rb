class Api::V1::UsersApiController < Api::V1::ApiController
  def info
    if params[:user_id]
      @user = User.find(params[:user_id])
      puts "finding using UID"
    else
      @user = current_user
      puts "using current user"
    end
    response.status = 200
  end
end
