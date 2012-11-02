class VotesMailer < ActionMailer::Base
  default from: "no-reply@mightbuy.it"

  def email_topic_owner(vote)
    @vote   = vote
    @voter  = vote.user
    @topic  = vote.topic
    @owner  = vote.topic.user

    from    = "#{@voter.name.capitalize} <no-reply@mightbuy.it>"
    subject = "[MB] A Vote on '#{@topic.subject.first(45)}'"
    mail to: @owner.email, from: from, subject: subject
  end
end
