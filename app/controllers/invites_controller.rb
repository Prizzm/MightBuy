class InvitesController < ApplicationController

  before_filter :find_user_with_invite_token
  layout 'logged_user'

  def show
    @topic = @user.topics.find_by_shortcode(params[:topic_id])
    @comments = @topic.ordered_comments
    @comment = Comment.new

    if current_user && @topic.owner?(current_user)
      @selected_tab = 'mightbuy'
    end
  end

  private
  def find_user_with_invite_token
    @user = User.find_by_invite_token!(params[:token])
    sign_in @user
  end
end
