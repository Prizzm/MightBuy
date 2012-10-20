module ProfileHelper
  
  def latest_posts
    resource.topics.mightbuy.order("created_at desc").limit(10)
  end
  
  def latest_activity
    resource.responses.order("created_at desc").limit(2)
  end
  
end
