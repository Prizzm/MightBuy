class VotesMailerJob < Struct.new(:vote_id)
  def vote
    @vote ||= Vote.includes(:user, topic: :user).find_by_id(vote_id)
  end

  def perform
    if vote && vote.user && vote.topic && vote.topic.user
      VotesMailer.email_topic_owner(vote).deliver if vote.user != vote.topic.user
    end
  end
end
