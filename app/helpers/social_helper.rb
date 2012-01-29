module SocialHelper
  
  def response_like (response, url)
    social_info_wrapper :recommend, response, facebook.like(url)
  end
  
  def response_tweet (response, url)
    title = response.topic.share_title
    title = response.topic.subject if title.blank?
    social_info_wrapper :tweet, response, twitter.tweet(h(title), url)
  end
  
  def social_info_wrapper (type, response, content)
    content_tag :div, content, :class => "#{type} social-info", :data => { :response_id => response.id }
  end
  
  def js_points_awarded
    message = flash.now[:points]
    flash.discard
    points_flash(message) unless message.blank?
  end
  
  def js_total_points
    "%sP" % current_user.points.available if current_user
  end
  
  def twitter_url_for (string)
    "http://twitter.com/%s" % string
  end
  
  def facebook
    @facebook ||= FacebookHelper
  end
  
  def twitter
    @twitter ||= TwitterHelper
  end
  
  def open_graph_tags
    [
      "\n",
      open_graph_tag( :type, :article ),
      open_graph_tag( :site_name, "Prizzm" ),
      open_graph_tag( :url, open_graph_info[:url] ),
      open_graph_tag( :title, h(open_graph_info[:title]) ),
      open_graph_tag( :description, h(open_graph_info[:desc]) ),
      open_graph_tag( :image, open_graph_info[:image] ),
      "\n"
    ].join("\n").html_safe
  end
  
  def open_graph_tag (name, content)
    ('<meta property="og:%s" content="%s" />' % [name, content]).html_safe
  end
  
  def open_graph_info
    {
      :title => title,
      :url   => request.url,
      :image => image_url("/images/app/open-graph-image.png"),
      :desc  => "Prizzm - collaborate with brands, share ideas & help make products you can't live without!"
    }
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
        data-show-faces="false" data-action="like"></div>'
        
      (button % url).html_safe
    end
    
  end
  
  module TwitterHelper
    
    def self.tweet (text, url)
      button = '<a href="https://twitter.com/share" class="twitter-share-button" data-url="%s" 
        data-text="%s" data-count="none" data-via="prizzmtwt">Tweet</a><script type="text/javascript" 
        src="//platform.twitter.com/widgets.js"></script>'
        
      (button % [url, text]).html_safe
    end
    
  end
  
end