class Notifications < ActionMailer::Base
  default from: "notification@prizzm.com"
  
  layout "notification"
  
  def feedback (invite)
    @invite  = invite
    @brand   = invite.inviter
    @user    = invite.invitee
    @product = invite.reference

    @to_email      = @user.email
    @from_email    = "%s@prizzm.com" % @brand.name.parameterize
    @subject = "%s thanks you for buying your new %s" % [ @brand.name, @product.name ]
    @message = "%s wants to know what you think of your %s :)" % [ @brand.name, @product.name ]

    mail \
      :to => @to_email,
      :from => "%s <%s>" % [ @brand.name, @from_email ],
      :subject => @subject
  end
  
end