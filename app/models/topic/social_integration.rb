module Topic::SocialIntegration
  def post_to_twitter(current_user)
    client = twitter_client(current_user)
    twitter_response = client.statuses.update! :status => compose_twitter_status(current_user)
    self.shares.tweets.create!(user: current_user, with: twitter_response.id_str)
  rescue Exception => e
    nil
  end

  def post_to_facebook(current_user)
    me = FbGraph::User.me(current_user.facebook_oauth_token)
    fb_response = me.feed!(compose_facebook_message)
    shares.recommends.create!(user: current_user, with: fb_response.identifier)
  rescue Exception => e
    Rails.logger.fatal(e.message)
    Rails.logger.fatal(e.backtrace.join("\n"))
    nil
  end

  def compose_facebook_message
    desctext = body.blank? ? "Track stuff you mightbuy" : body

    message = {
      message: "I MightBuy a #{subject}. #{displayPrice} Should I?",
      link: "https://www.mightbuy.it/topics/#{to_param}",
      name: "MightBuy",
      description: desctext
    }

    if iImage() != "https://www.mightbuy.it/assets/no_image.png"
      message.update(picture: iImage())
    end

    message
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

  def tweeted_by?(user)
    !!shares.tweets.find_by_user_id(user.id)
  end

end

