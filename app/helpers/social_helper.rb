module SocialHelper
  
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
        data-text="%s" data-count="none" data-via="prizzmtwt">Tweet</a><script type="text/javascript" 
        src="//platform.twitter.com/widgets.js"></script>'
        
      (button % [url, text]).html_safe
    end
    
  end
  
end