class ApplicationController < ActionController::Base

  # Forgery Protection
  protect_from_forgery
  
  # Filters
  
  before_filter do
    cookies[:visitor_code] ||= {
      :value => Shortcode.new(40),
      :expires => 1.week.from_now
    }
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
  
    def award_points
      if current_user && current_user.points.awarded > 0
        flash[:points] = "You just earned <strong>%s</strong> points!" % current_user.points.awarded
        current_user.points.save
      end
    end
  
    def visitor_code
      cookies[:visitor_code]
    end
  
    def self.authenticate! (options = {})
      before_filter :authenticate_user!, options
    end
end