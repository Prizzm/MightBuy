class Comment < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  belongs_to :parent, class_name: "Comment"
  has_many   :replies, class_name: "Comment"

  validates  :topic, :description, presence: true


  def self.update_user(comment_id, user)
    if comment_id && comment = Comment.find_by_id(comment_id)
      comment.update_attributes(user_id: user.id)
    else
      false
    end
  end
end
