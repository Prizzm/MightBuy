class Api::V1::CommentsController < Api::V1::ApiController
  respond_to :json
  before_filter :find_topic
  
  def index
    @comments = @topic.comments
    present @comments, :with => Entity::Comment, :status => 200
  end

  private
  def find_topic
    if params[:topic_shortcode]
      @topic = Topic.find_by_shortcode(params[:topic_shortcode])
    elsif params[:topic_id]
      @topic = Topic.find(params[:topic_id])
    else
      render :text => {:error => {:description => "No Topic Specified"}}.to_json
    end
  end

end
