class TagsController < ApplicationController
  before_filter :find_tag, :only => [:show, :topics, :update]
  layout :choose_layout
  respond_to :html, :js

  def topics
    page = params[:page] || 1
    @topics = @tag.topics.page(page).per(10)
    if request.xhr?
      render :partial => "/topics/topic_list"
    end
  end

  def update_tags
    
  end

  private
  def find_tag
    @tag = Tag.find_by_name(params[:id])
  end

  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end
end
