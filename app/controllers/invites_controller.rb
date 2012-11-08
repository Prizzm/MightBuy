class InvitesController < ApplicationController

  before_filter :find_user_with_invite_token

  def show
    @topic = @user.topics.find(params[:topic_id])
  end

  private
  def find_user_with_invite_token
    @user = User.find_by_invite_token!(params[:token])
    sign_in @user
  end
end
