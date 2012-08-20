class Api::V1::UsersApiController < ApplicationController
  def info
    @user = current_user
  end
  
  def new
    u = User.new()
    u.name = params[:name]
    u.email = params[:email]
    u.password = params[:password]
    u.password_confirmation = params[:password]
    u.save
  end
end
