module SocialHelper

  def facebook_share_button
    social_share_button :facebook
  end

  def twitter_share_button
    social_share_button :twitter
  end

  def social_share_button(type)
    content_tag :div, image_tag("/assets/#{type}_share_button.png", :alt => "Share on #{type.to_s.capitalize}"), :id => type
  end

  def response_like (response, url)
    url = ShareTracker.tag(url, response.topic)
    social_info_wrapper :recommend, response, facebook.like(url)
  end

  def response_tweet (response, url)
    url   = ShareTracker.tag(url, response.topic)
    title = response.topic.share_title
    title = response.topic.subject if title.blank?
    social_info_wrapper :tweet, response, twitter.tweet(h(title), url)
  end

  def topic_tweet(topic)
    title = "I might buy #{topic.share_title || topic.subject} #{topic_url}"
    social_info_wrapper :tweet, topic, twitter.tweet(h(title), topic_url(topic))
  end

  def topic_fb_send(topic)
    social_info_wrapper :recommend, topic, facebook.like(topic_url(topic))
  end

  def social_info_wrapper (type, object, content)
    content_tag :div, content, :class => "#{type} social-info", :data => { "#{object.class.to_s.downcase}_id".to_sym => object.id }
  end

  def twitter_url_for(string)
    "http://twitter.com/%s" % string
  end

  def facebook
    @facebook ||= FacebookHelper
  end

  def twitter
    @twitter ||= TwitterHelper
  end


  module FacebookHelper
    def self.script
      script = <<-EOF
        <div id="fb-root"></div>
        <script>(function(d, s, id) {
          var js, fjs = d.getElementsByTagName(s)[0];
          if (d.getElementById(id)) {return;}
          js = d.createElement(s); js.id = id;
          js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
          fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>
      EOF

      script.html_safe
    end

    def self.like (url)
      button = '<div class="fb-like" data-href="%s" data-send="true" data-layout="button_count"
        data-show-faces="false" data-action="recommend"></div>'

      (button % url).html_safe
    end
  end


  module TwitterHelper
    def self.tweet (text, url)
      button = '<a href="https://twitter.com/share" class="twitter-share-button" data-url="%s"
        data-text="%s" data-count="none" data-via="Mightbuy">Tweet</a><script type="text/javascript"
        src="//platform.twitter.com/widgets.js"></script>'

      (button % [url, text]).html_safe
    end
  end
end
