class CommentsMailer < ActionMailer::Base
  default from: "no-reply@mightbuy.it"

  def email_topic_owner(comment)
    @comment   = comment
    @commenter = comment.user
    @receiver  = comment.topic.user

    from    = "#{@commenter.name.capitalize} <no-reply@mightbuy.it>"
    subject = "[MB] You have received new comment on '#{@comment.topic.subject.first(45)}'"
    mail to: @receiver.email, from: from, subject: subject
  end
end
