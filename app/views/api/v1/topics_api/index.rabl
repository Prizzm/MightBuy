collection @topics
attributes :id, :shortcode, :subject, :body, :access, :type, :created_at, :updated_at, :recommendable, :url, :share_title, :price, :offer

node(:image_url) { |topic|
	if topic.image
		"http://mightbuy.it#{topic.image.url}"
	end
}