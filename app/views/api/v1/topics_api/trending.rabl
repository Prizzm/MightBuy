collection @topics
attributes :id, :shortcode, :subject, :body, :access, :type, :created_at, :updated_at, :recommendable, :url, :share_title, :price, :offer, :comments

node(:image_url) { |topic|
	topic.iImage()
}
