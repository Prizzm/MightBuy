class Notifications < ActionMailer::Base
  default from: "notify@mightbuy.it"
  
  layout "notification"
  
  def share (share)
    @topic = share.topic
    @user  = share.user
    @name = @user ? @user.name : "Someone"
    @bannername = ("%s wants your opinion..") % @name  
    @homeurl = @topic.url
      
    @to_email   = share.with
    @from_email = "notify@mightbuy.it"
    @heading    = @topic.subject
      
    @topic_url = invited_url(share.shortcode);
      
    mail \
      :to => @to_email,
      :from => "%s <%s>" % [ @name, @from_email ],
      :subject => @heading
  end
  
  def responded (response)
    @model   = response
    @heading = "%s has responded to you." % 
      (response.user ? response.user.name : "Someone")
    
    @to_email   = response.reply_to_email
    @from_email = "notify@mightbuy.it"
    @url        = topic_url(response.topic, :feature => response.id)
    
    @title      = response.topic.subject
    @message    = response.body
    
    mail \
      :to => @to_email,
      :from => "MightBuy <%s>" % @from_email,
      :subject => @heading
    
  end
  
end