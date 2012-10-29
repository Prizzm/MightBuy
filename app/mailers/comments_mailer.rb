class CommentsMailer < ActionMailer::Base
  default from: "no-reply@mightbuy.it"

  def email_topic_participant(participant, comment)
    @comment   = comment
    @commenter = comment.user
    @receiver  = participant

    from    = "#{@commenter.name.capitalize} <no-reply@mightbuy.it>"
    subject = "[MB] New comment on '#{@comment.topic.subject.first(45)}'"
    mail to: @receiver.email, from: from, subject: subject
  end
end
