module RouterHelper
  
  def register_points
    Points.allocators[:registering]
  end
  
end