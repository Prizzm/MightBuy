object @user
attributes :email, :remember_me, :name, :visitor_code, :url, :description, :facebook, :twitter, :phone, :category, :inherit_upload_id

node(:image_url) do |user|
	if user.image then
		user.image.url(:host => "https://mightbuy.it.it")
	end
end