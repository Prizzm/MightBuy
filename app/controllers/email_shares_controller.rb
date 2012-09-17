class EmailSharesController < ApplicationController
  before_filter :authenticate_user!, :find_topic!
  layout "logged_user"

  def new
    @selected_tab = 'mightbuy'
  end

  def create
    email_attributes = params[:topic] && params[:topic][:email_shares_attributes]
    if @topic.update_attributes(email_shares_attributes: email_attributes)
      flash[:notice] = "Sending Mails in Process"
      redirect_to topic_path(@topic.shortcode)
    else
      flash[:error] = "Failed to Send Mails"
      render "new"
    end
  end

  private
  def find_topic!
    unless @topic = current_user.topics.find_by_shortcode(params[:topic_id])
      redirect_to root_path
    end
  end
end
