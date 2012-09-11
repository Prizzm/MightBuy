class CommentsController < ApplicationController
  before_filter :find_topic!
  respond_to :html, :js

  def create
    @comment = @topic.comments.build(params[:comment])
    @comment.user = current_user

    if @comment.save && current_user.nil?
      session[:comment_id] = @comment.id
      session[:redirect_path] = topic_path(@topic)
    end

    location_path = current_user ? topic_path(@topic) : new_user_session_path
    respond_with(@comment, location: location_path)
  end
end
