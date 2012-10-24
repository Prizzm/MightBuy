class Comment < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  belongs_to :parent, class_name: "Comment"
  has_many   :replies, class_name: "Comment"

  validates  :topic, :description, presence: true

  has_many :timeline_events, as: :subject, dependent: :destroy

  fires :new_comment, on: :create, actor: :user, secondary_subject: :topic

  def self.update_user(comment_id, user)
    if comment_id && comment = Comment.find_by_id(comment_id)
      comment.update_attributes(user_id: user.id) && comment.send_notifications
    else
      false
    end
  end

  def activity_line(timeline_event)
    actor,topic = timeline_event.actor, timeline_event.secondary_subject
    "#{actor.name} commented on <a href='/users/#{topic.user.id}'>#{topic.user.name}'s</a> <a href='/topics/#{topic.to_param}'>#{topic.subject.first(45)}..</a> on mightbuy".html_safe
  end

  def send_notifications
    Delayed::Job.enqueue( ::CommentsMailerJob.new(self.id) )
  end
end
