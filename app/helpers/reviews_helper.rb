module ReviewsHelper

  def prizzm_like
    code = <<-EOF
      <div id="fb-root"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));</script>

      <div class="fb-like" data-href="http://www.prizzm.com" data-send="true" 
        data-layout="button_count" data-width="150" data-show-faces="false"></div>
    EOF
    code.html_safe
  end
  
  def prizzm_tweet
    code = <<-EOF
      <a href="https://twitter.com/share" class="twitter-share-button" data-url="http://www.prizzm.com" 
      data-text="I'm on the beta list for Prizzm! Check it out!" data-count="horizontal" data-via="prizzmtwt">Tweet</a>
      <script type="text/javascript" src="//platform.twitter.com/widgets.js"></script>
    EOF
    code.html_safe
  end
  
end