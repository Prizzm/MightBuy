class TagsController < ApplicationController
  before_filter :find_tag, :only => [:show, :topics]
  layout :choose_layout
  respond_to :html, :js

  def topics
    page = params[:page] || 1
    @topics = @tag.topics.order("created_at desc").page(page).per(10)
    if request.xhr?
      render :partial => "/topics/topic_list"
    end
  end

  def update_tags
    @topic = Topic.find_by_shortcode(params["topic_id"])
    if @topic && @topic.owner?(current_user)
      incoming_tags = params["tags"]
      incoming_tags = [] if incoming_tags.blank?

      @topic.update_tags(incoming_tags)
      head :accepted
    else
      head :bad_request
    end
  end

  private
  def find_tag
    @tag = Tag.find_by_name(params[:id])
  end

  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end
end
