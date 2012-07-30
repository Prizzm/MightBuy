class Topic < ActiveRecord::Base
  
  # Includes
  include InheritUpload
  include ActionView::Helpers::NumberHelper
  
  # Options
  Access = {
    "Anyone." => "public",
    "Only by Invite." => "private"
  }
  
  # Relationships
  has_many :responses
  has_many :shares, :class_name => "Shares::Share", :inverse_of => :topic
  belongs_to :user
  belongs_to :product
  
  # Scopes
  scope :publics, where(:access => "public")
  scope :privates, where(:access => "private")
  
  # Validations
  validates :access, :presence => { :message => "Please select one of the above :)" }
  validates :shortcode, :presence => true, :uniqueness => true
  validates :subject, :presence => true
  #validates :body, :presence => true
  
  # Uploaders
  image_accessor :image
  
  # Social  
  
  # Methods
  after_create :find_product
  
  def find_product
    p = Product.find_by_url(url)
    if p then
      self.update_attribute("product_id", p)
    end
  end

  # Nested Attributes
  accepts_nested_attributes_for :shares,
    :reject_if => proc { |attributes| attributes["with"].blank? }
  
  # Attributes
  attr_accessor :pass_visitor_code
  
  def displayPrice
    if self.price then
      return " #{number_to_currency(self.price)}."
    else
      return ""
    end
  end
  
  def iImage(host = true)
    # Check if mobile image exists - return
    if self.mobile_image_url then
      # If a mobile image exists then return mobile_image_url
      # https://s3.amazonaws.com/prizzm-invites/images/9271954A-0F0A-4579-AE5D-D53199B154C2.png
      return self.mobile_image_url

    else #handle non mobile images as no images
      
      if host == true then
        # Check env 
        if Rails.env.production? then
          if self.image then 
            # Return image.url with host
            # http://mightbuy.it/topics/43P16H (mightbuy.it)
            return self.image.url(:host => "http://mightbuy.it")
          else
            return "http://mightbuy.it/images/app/noimage.png"
          end  
        else
          if self.image then 
            # Return image.url with host
            # http://localhost.it/topics/43P16H (localhost)
            return self.image.url(:host => "http://localhost:3000")
          else 
            return "http://localhost:3000/images/app/noimage.png"
          end      
        end
    
      else #host is not true - handle blank and 
        # Other image.url without host (Path Only)
        # /topics/43P16H
        if self.image then 
          return self.image.url
        else
          return   "/images/app/noimage.png"
        end
      end  
    end     
    
  end
  
  def url
    url = attributes['url']
    url.blank? ? url : Scrape.full_url(url)
  end
  
  def post?
    !question?
  end
  
  def question?
    subject[/\?\s*$/i] ? true : false
  end
  
  def form?
    form.to_s.to_sym
  end
  
  def to_param
    shortcode
  end
  
  def share_csv= (file)
    Importer.csv(file, self)
  end
  
  def stats
    @stats ||= Statistics.for(self)
  end
  
end