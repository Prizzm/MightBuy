module HavesHelper
  def recommend_text(topic)
    if topic.recommended?
      topic.user.try(:name).to_s + " recommends this item."
    else
      topic.user.try(:name).to_s + " has not recommend this item yet."
    end
  end
end
