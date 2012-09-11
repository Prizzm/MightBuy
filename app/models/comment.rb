class Comment < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  belongs_to :parent, class_name: "Comment"
  has_many   :replies, class_name: "Comment"

  validates  :topic, :user, :description, presence: true
end
