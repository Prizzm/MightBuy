class EmailSharesController < ApplicationController
  before_filter :authenticate_user!, :find_topic!
  layout "logged_user"
  respond_to :html, :js

  def new
    @selected_tab = @topic.ihave? ? 'ihave' : 'mightbuy'
  end

  def create
    email_attributes = params[:topic] && params[:topic][:email_shares_attributes]
    if @topic.update_attributes(email_shares_attributes: email_attributes)
      flash[:notice] = "Sending Mails in Process"
    else
      flash[:error] = "Failed to Send Mails"
    end

    respond_with (@topic) do |format|
      format.html do
        @topic.errors.empty? ? redirect_to(topic_path(@topic.shortcode)) : render("new")
      end
      format.js
    end
  end

  private
  def find_topic!
    unless @topic = current_user.topics.find_by_shortcode(params[:topic_id])
      redirect_to root_path
    end
  end
end
