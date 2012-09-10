class ResponsesController < ApplicationController
  before_filter :find_topic!
  respond_to :html, :js

  def create
    @topic_response = @topic.responses.build(params[:response])
    @topic_response.user = current_user

    if @topic_response.save && current_user.nil?
      session[:response_id]  = @topic_response.id
      session[:redirect_path] = topic_path(@topic, r: :t)
    end

    location_path = current_user ? topic_path(@topic, r: :t) : new_user_session_path
    respond_with(@topic, location: location_path)
  end

  private
  def find_topic!
    unless @topic = Topic.find_by_shortcode(params[:topic_id])
      respond_with(@topic, location: root_path)
    end
  end
end
