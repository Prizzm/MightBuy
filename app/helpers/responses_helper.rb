module ResponsesHelper
  
  def render_recommend_type (response)
    type = response.recommend_type
    type = "recommend" if response.recommended
    
    unless type.blank?
      label = case type
        when "recommend" then "I recommend this!"
        when "undecided" then "I'm undecided about this."
        when "not_recommended" then "I do not recommend this!"
      end
      content_tag :div, :class => "recommend-type" do
        content_tag :span, label, :class => type
      end
    end
  end
  
  def recommendation_points_awarded
    message = "You just earned <strong>%s</strong> points!" % recommendation_total_points
    points_flash(message)
  end
  
  def recommendation_total_points
    "%sP" % recommendation_points_earned
  end
  
  def recommendation_points_earned
    points = Points.allocators[:recommending]
    unless resource.body.blank?
      points += Points.allocators[:giving_more_feedback]
    end
    points
  end
  
end