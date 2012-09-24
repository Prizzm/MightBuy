class ApplicationController < ActionController::Base
  respond_to :html, :js

  # Forgery Protection
  protect_from_forgery

  # Filters

  before_filter :update_last_seen
  before_filter :set_selected_tab

  before_filter do
    cookies[:visitor_code] ||= {
      :value => Shortcode.new(40),
      :expires => 1.week.from_now
    }

    unless params[:points].blank?
      cookies[:disable_points] = params[:points] == 'false'
    end
  end

  # If points were awarded, show a flash..
  after_filter :award_points

  # Actions

  def self.index_with_xhr
    define_method :index do
      respond_to do |wants|
        wants.html do
          !request.xhr? ?
          render("application/index") :
            render("index.xhr", :layout => false)
        end
      end
    end
  end

  private

  helper_method :visitor_code

  def award_points
    if current_user && current_user.points.awarded > 0
      flash[:points] = "You just earned <strong>%s</strong> points!" % current_user.points.awarded
      current_user.points.save
    end
  end

  def visitor_code
    cookies[:visitor_code]
  end

  def flash_helper
    f_names = [:notice, :warning, :message]
    fl = ''
    for name in f_names
      if flash[name]
        fl = fl + "<div class=\"notice\">#{flash[name]}</div>"
      end
      flash[name] = nil;
    end
    return fl
  end

  def update_last_seen
    if current_user then
      current_user.update_attribute("last_seen", DateTime.now)
    end
  end

  def set_selected_tab
    @selected_tab = 'everybody'
  end

  def self.authenticate! (options = {})
    before_filter :authenticate_user!, options
  end

  def after_sign_in_path_for(user)
    session_actions
    @session_redirect_path ||= session.delete(:redirect_path)
    @session_redirect_path ||= user_root_path
  end
  attr_reader :session_redirect_path
  helper_method :session_redirect_path

  def session_actions
    update_vote
    update_comment
  end

  def update_vote
    if vote_id = session.delete(:vote_id)
      if Vote.update_user(vote_id, current_user)
        flash[:notice] = t("voting.success")
      else
        flash[:error]  = t("voting.failed")
      end
    end
  end

  def update_comment
    if comment_id = session.delete(:comment_id)
      if Comment.update_user(comment_id, current_user)
        flash[:notice] = t("commenting.success")
      else
        flash[:error]  = t("commenting.failed")
      end
    end
  end

  def find_topic!
    unless @topic = Topic.find_by_shortcode(params[:topic_id])
      respond_with(@topic, location: root_path)
    end
  end

end
