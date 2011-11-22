class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
    def give_points_for (allocator, options)
      if current_user
        if current_user.points.add( allocator, options )
          current_user.points.save
          flash[:points] = "You just earned <strong>%s</strong> points!" % Points.allocators[allocator]
        end
      end
    end
    
end