ActiveAdmin.register Topic do
  
  index do
    column "ID" do |topic|
      link_to topic.id, admin_topic_path(topic)
    end
    
    column "User" do |topic|
      link_to topic.user.name, admin_user_path(topic.user)
    end
    
    column :subject
    column :shortcode
    column :created_at
  end
  
end