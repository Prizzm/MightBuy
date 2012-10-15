module Entity
  class User < Grape::Entity
    expose :id
    expose :email
    expose :name
  end

  class Topic < Grape::Entity
    expose :id
    expose :subject
    expose :shortcode
    expose :user_id
    expose :body
    expose :url
    expose(:thumbnail) {|tp| tp.thumbnail_image }
  end

  class Comment < Grape::Entity
    expose :id
    expose :topic_id
    expose :user_id
    expose :description
    expose :user
  end
  
  class User < Grape::Entity
    expose :id
    expose :email
    expose :name
    expose :image
    expose :last_seen
  end
end
