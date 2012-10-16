module Topic::Trends
  extend ActiveSupport::Concern

  module ClassMethods
    def trending_topics
      busiest_products = Product.busiest_products(20)

      busiest_topics = busiest_products.map { |product| product.topics.first }

      topic_with_most_comments = with_most_comments(30)

      selected_topics_with_comments = []
      topic_with_most_comments.each do |topic|
        unless busiest_products.include?(topic.product)
          selected_topics_with_comments << topic
          busiest_products << topic.product
        end
      end

      busiest_topics + selected_topics_with_comments
    end

    def with_most_comments(count = 30)
      Topic.select("topics.*,c.comment_count").
        joins("JOIN (select topic_id, count(topic_id) as comment_count from comments group by topic_id) c ON c.topic_id = topics.id").
        order("c.comment_count desc").
        limit(count)
    end
  end

end
