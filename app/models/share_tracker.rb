require 'uri'

module ShareTracker
  
  def self.tag (url, topic)
    URI.parse(url).tap do |uri|
      uri.query = [ uri.query, "prizzm=%s" % topic.shortcode ].compact.join("&")
    end.to_s
  end
  
  def self.get (url)
    shortcode = Rack::Utils.parse_query(URI.parse(url).query)["prizzm"]
    Topic.find_by_shortcode(shortcode)
  end
end