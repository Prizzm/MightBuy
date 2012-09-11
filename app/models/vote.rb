class Vote < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  validates  :topic, presence: true

  def self.update_user(vote_id, user)
    if vote_id && vote = Vote.find_by_id(vote_id)
      vote.update_attributes(user_id: user.id)
    end
  end
end
