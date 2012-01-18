module RouterHelper
  
  def register_points_awarded
    message = "You just earned <strong>%s</strong> points!" % register_points
    points_flash message
  end
  
  def register_points
    Points.allocators[:registering]
  end
  
end