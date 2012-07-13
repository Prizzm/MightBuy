class Api::V1::UsersApiController < ApplicationController
  def info
    @user = current_user
  end
end
