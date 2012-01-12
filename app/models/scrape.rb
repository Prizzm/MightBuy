module Scrape
  
  def self.images (url)
    scraper = ImageScraper::Client.new(url.to_s)
    scraper.page_images
  end
  
  def self.product (url)
    open url do |file|
      uri = URI.parse(url);
      doc = Nokogiri::HTML(file.read);
      images = doc.search('img').map { |element| (uri + element['src']).to_s }

      return {
        :product => doc.title,
        :images => images
      }
    end rescue false
  end
  
end