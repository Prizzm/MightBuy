module ResponsesHelper
  
  def render_recommend_type (response)
    type = response.recommend_type
    type = "recommend" if response.recommended
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