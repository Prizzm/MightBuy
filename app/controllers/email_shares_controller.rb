class EmailSharesController < ApplicationController
  before_filter :authenticate_user!, :find_topic!
  layout "logged_user"

  def new
    @topic.email_shares.build
    @topic.email_shares.build

    @selected_tab = 'mightbuy'
  end

  def create
    render "new"
  end

  private
  def find_topic!
    unless @topic = current_user.topics.find_by_shortcode(params[:topic_id])
      redirect_to root_path
    end
  end
end
