object @user
attributes :id, :email, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :name, :created_at, :updated_at, :url, :description, :facebook, :twitter, :phone, :email_address, :category, :facebook_uid, :twitter_uid, :facebook_oauth_token, :twitter_oauth_token, :twitter_oauth_secret, :last_seen, :topics

node(:image_url) do |user|
	if user.image then
		user.image.url(:host => "https://www.mightbuy.it")
	end
end