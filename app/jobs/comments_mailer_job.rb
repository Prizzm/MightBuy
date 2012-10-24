class CommentsMailerJob < Struct.new(:comment_id)
  def perform
    comment = Comment.includes(:user, topic: :user).find_by_id(comment_id)
    if comment && comment.user && comment.topic && comment.topic.user
      CommentsMailer.email_topic_owner(comment).deliver
    end
  end
end
