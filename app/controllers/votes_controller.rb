class VotesController < ApplicationController
  before_filter :find_topic!
  respond_to :html, :js

  def create
    buyit = params[:vote] == "yes"
    @vote = @topic.vote(current_user, buyit)
    @topic.reload
    if @vote.errors.empty? && current_user.nil?
      session[:vote_id] = @vote.id
      session[:redirect_path] = topic_path(@topic)
    end
    location_path = current_user ? topic_path(@topic) : new_user_session_path
    respond_with(@vote, location: location_path)
  end
end
