module Topic::SocialIntegration
  def post_to_twitter(current_user)
    client = twitter_client(current_user)
    twitter_response = client.statuses.update! :status => compose_twitter_status(current_user)
    self.shares.tweets.create!(user: current_user, with: twitter_response.id_str)
  rescue Exception => e
    nil
  end

  def compose_twitter_status(current_user)
    "I #mightbuy #{subject.first(45)}.. #{displayPrice} Should I? #{MB.config.app_url}/topics/#{shortcode}"
  end

  def twitter_client(current_user)
    Grackle::Client.new(auth: {
      type: :oauth,
      consumer_key: MB.config.twitter_appid, consumer_secret: MB.config.twitter_token,
      token: current_user.twitter_oauth_token, token_secret: current_user.twitter_oauth_secret
    })
  end
end

