class Vote < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  validates  :topic, presence: true

  has_many :timeline_events, as: :subject
  fires :new_comment, on: :create, actor: :user, secondary_subject: :topic

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

  def activity_line(actor, topic)
    "#{actor.name} #{like_dislike_text} <a href='/users/#{topic.user.id}'>#{topic.user.name}'s</a> <a href='/topics/#{topic.id}'>#{topic.subject.first(45)}..</a> on mightbuy.".html_safe
  end
end
