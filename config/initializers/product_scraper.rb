require 'iconv'

module ProductScraper
  class Client < ImageScraper::Client

    def product_price
      price = nil
      return price if doc.blank?
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      prices = ic.iconv(doc.text).scan( /\$[0-9]+(?:\.[0-9]?[0-9]?)?/ ).collect { |p| p[1..-1] }
      # get first non-zero price
      prices.each do |p|
        if p.to_f > 0
          price = p
          break
        end
      end
      price
    end

    def product_data
      {
        :images => self.page_images,
        :price => self.product_price
      }
    end
  end
end
