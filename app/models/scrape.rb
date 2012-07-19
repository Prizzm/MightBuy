module Scrape
  
  def self.images (url)
    scraper = ProductScraper::Client.new(full_url(url))
    scraper.product_data
  end
  
  def self.product (url)
    url = full_url(url)
    
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
  
  private
  
    def self.full_url (url)
      url[/^https?:\/\//] ? "#{url}" : "http://#{url}"
    end
  
end
