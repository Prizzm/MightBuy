class Notifications < ActionMailer::Base
  default from: "notify@prizzm.com"
  
  layout "notification"
  
  def share (share)
    @topic = share.topic
    @user  = share.user
    @name = @user ? @user.name : "Someone"
    
    @to_email   = share.with
    @from_email = "notify@prizzm.com"
    @heading    = (@topic.question? ? 
      "%s wants your opinion.." : 
      "%s shared this with you..") % @name
      
    @topic_url = invited_url(share.shortcode);
      
    mail \
      :to => @to_email,
      :from => "%s <%s>" % [ @name, @from_email ],
      :subject => @heading
  end
  
  def responded (response)
    @model = response
    
    @heading = "%s has responded to your post." % 
      (response.user ? response.user.name : "Someone")
      
    @to_email = response.topic.user.email
    @from_email = "notify@prizzm.com"
    @url     = topic_url(response.topic)
    
    @title   = response.topic.subject
    @message = response.body
    
    mail \
      :to => @to_email,
      :from => "Prizzm <%s>" % @from_email,
      :subject => @heading
  end
  
end