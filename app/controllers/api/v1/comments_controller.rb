class Api::V1::CommentsController < ApplicationController
  before_filter :find_topic

  def index
    @comments = @topic.comments
    present @comments, :with => Entity::Comment, :status => 200
  end

  private
  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def present(api_response, options = {})
    body_hash = options[:with].represent(api_response)
    render :json => body_hash, :status => options[:status]
  end
end
