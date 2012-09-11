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

  has_many :topic_tags
  has_many :tags, :through => :topic_tags
  
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
      t = self
      t.product = p
      t.save
    else
      t = self   
      pn = Product.new()
      
      pn.name = t.subject
      pn.url = t.url
      pn.save
      
      t.product = pn
      t.save
    end
  end

  # Nested Attributes
  accepts_nested_attributes_for :shares,
    :reject_if => proc { |attributes| attributes["with"].blank? }
  
  # Attributes
  attr_accessor :pass_visitor_code

  def displayPrice
    if self.price
      return " #{number_to_currency(self.price)}."
    else
      return ""
    end
  end

  def thumbnail_image
    if image
      image.thumb("187x137").url
    else
      "/assets/no_image.png"
    end
  end
  
  def iImage(host = true)
    if host == true then
      # Check env 
      if Rails.env.production? then
        if self.image then 
          # Return image.url with host
          # https://www.mightbuy.it/topics/43P16H (mightbuy.it)
          return self.image.url(:host => "https://www.mightbuy.it")
        else
          return "https://www.mightbuy.it/assets/no_image.png"
        end  
      else
        if self.image then 
          # Return image.url with host
          # http://localhost.it/topics/43P16H (localhost)
          return self.image.url(:host => "http://localhost:3000")
        else 
          return "https://www.mightbuy.it/assets/no_image.png"
        end      
      end
    else #host is not true - handle blank and 
      # Other image.url without host (Path Only)
      # /topics/43P16H
      if self.image then 
        self.image.url
      else
        "https://www.mightbuy.it/assets/no_image.png"
      end
    end
  end

  def update_topic_with_image(params)
    if params[:image_url] && URI.parse(URI.encode(params[:image_url])).host
      params[:image_url] = URI.parse(URI.encode(params[:image_url])).to_s
    else
      params.delete(:image_url)
    end
    update_attributes!(params)
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

  def tweeted_by?(user)
    !!shares.tweets.find_by_user_id(user.id)
  end

  def recommended_by?(user)
    !!shares.recommends.find_by_user_id(user.id)
  end
end
