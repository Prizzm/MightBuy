class Vote < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  validates  :topic, presence: true

  has_many :timeline_events, as: :subject, dependent: :destroy

  fires :new_vote, on: :create, actor: :user, secondary_subject: :topic

  def self.update_user(vote_id, user)
    if vote_id && vote = Vote.find_by_id(vote_id)
      if existing_vote = Vote.find_by_topic_id_and_user_id(vote.topic.id, user.id)
        existing_vote.update_attributes(buyit: vote.buyit)
        vote.destroy
      else
        vote.update_attributes(user_id: user.id)
      end
    else
      false
    end
  end

  def like_dislike_text
    buyit ? 'liked' : 'did not like'
  end

  def activity_line(timeline_event)
    actor,topic = timeline_event.actor, timeline_event.secondary_subject

    owner_link =
      if topic.user.try(:id)
        "<a href='/users/#{topic.user.id}'>#{topic.user.name}'s</a>"
      else
        "Anonymous's"
      end

    "#{actor.name} #{like_dislike_text} #{owner_link} <a href='/topics/#{topic.to_param}'>#{topic.subject.first(45)}..</a> on mightbuy.".html_safe
  end
end
