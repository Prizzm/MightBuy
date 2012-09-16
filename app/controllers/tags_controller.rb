class TagsController < ApplicationController
  before_filter :find_tag, :only => [:show, :topics]
  layout :choose_layout

  def topics
    @topics = @tag.topics
  end

  private
  def find_tag
    @tag = Tag.find_by_name(params[:id])
  end

  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end
end
