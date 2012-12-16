class InvitesController < InheritedResources::Base
  include ProfileHelper

  before_filter :find_user_with_invite_token, only: :show

  # Defaults
  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user'

  layout 'logged_user'

  def show
    if params[:topic_id]
      @topic = @user.topics.find_by_shortcode(params[:topic_id])
      @comments = @topic.ordered_comments
      @comment = Comment.new
    else
      @topics = @user.topics
      @topic = @topics.first
    end

    @selected_tab = 'mightbuy'
  end

  def update_password
    user_params = params[:user]
    if current_user.update_password_with_validations(user_params[:password],user_params[:password])
      flash[:notice] = "Password successfully updated"
      sign_in current_user, bypass: true
    else
      flash[:error] = "Error updating password"
    end
  end

  private
  def find_user_with_invite_token
    @customer_lead = CustomerLead.find_by_invite_token!(params[:token])
    @user = @customer_lead.user
    if @user
      @customer_lead.accept!
      sign_in @user
    else
      raise ActiveRecord::RecordNotFound, "Couldn't find user with the token"
    end
  end
end
