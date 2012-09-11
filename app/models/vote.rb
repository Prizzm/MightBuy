class Vote < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  validates  :topic, :user, presence: true
end
