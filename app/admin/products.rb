ActiveAdmin.register Product do
  show do
    attributes_table do
      row :id
      row :name
      row :url
      row "Topics" do |product|
        span "total: #{product.topics.count}"
        ul do
          product.topics.each do |topic|
            li link_to topic.user.name, topic_path(topic)
          end
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
