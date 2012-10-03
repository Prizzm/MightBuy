class Api::V1::CommentsController < Api::V1::ApiController
  respond_to :json
  before_filter :find_topic

  def index
    @comments = @topic.comments
    present @comments, :with => Entity::Comment, :status => 200
  end

  private
  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

end
