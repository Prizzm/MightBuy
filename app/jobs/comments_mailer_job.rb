class CommentsMailerJob < Struct.new(:comment_id)
  def comment
    @comment ||= Comment.includes(:user, topic: :user).find_by_id(comment_id)
  end

  def topic
    comment.topic
  end

  # emails should be sent to all the participants, including the owner
  def mailable_topic_participants
    participants = topic.commenters.exclude(comment.user).to_a

    if topic.user != comment.user && !participants.include?(topic.user)
      participants += [topic.user]
    end

    participants
  end

  # send emails to all mailable participants
  def send_comment_notifications_to_commenters
    mailable_topic_participants.each do |participant|
      CommentsMailer.email_topic_participant(participant, comment).deliver
    end
  end

  def perform
    if comment && comment.user && comment.topic && comment.topic.user
      send_comments_notification_to_commenters
    end
  end
end
