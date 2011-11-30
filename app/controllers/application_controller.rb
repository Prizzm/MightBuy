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
  after_filter do
    if current_user && current_user.points.awarded > 0
      flash[:points] = "You just earned <strong>%s</strong> points!" % current_user.points.awarded
      current_user.points.save
    end
  end
  
  private
  
    def visitor_code
      cookies[:visitor_code]
    end
  
    def self.authenticate! (options = {})
      before_filter :authenticate_user!, options
    end
    
end