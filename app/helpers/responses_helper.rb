module ResponsesHelper
  
  def render_recommend_type (response)
    type = response.recommend_type
    type = "recommend" if response.recommended
    
    unless type.blank?
      label = case type
        when "recommend" then "Buy it!"
        when "undecided" then "Not sure..."
        when "not_recommended" then "Don't buy it!"
      end
      content_tag :div, :class => "recommend-type" do
        content_tag :span, label, :class => type
      end
    end
  end
  
  def recommendation_points_earned(response)
    points = Points.allocators[:responding]
    unless response.body.blank?
      points += Points.allocators[:giving_more_feedback]
    end
    points
  end
  
end
