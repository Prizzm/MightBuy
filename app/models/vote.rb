class Vote < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  validates  :topic, presence: true

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
end
