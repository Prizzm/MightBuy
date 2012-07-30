 ActiveAdmin.register User do
  
  index do
    column "ID" do |user|
      link_to user.id, admin_user_path(user)
    end
    column :name
    column :email
    column :created_at
    column :updated_at
  end
  
end
