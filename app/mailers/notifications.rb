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
      
    mail \
      :to => @to_email,
      :from => "%s <%s>" % [ @name, @from_email ],
      :subject => @heading
  end
  
end