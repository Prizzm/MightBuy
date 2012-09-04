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
  
  attr_accessor :tags # TODO : Remove it, temporary
  
  def displayPrice
    if self.price then
      return " #{number_to_currency(self.price)}."
    else
      return ""
    end
  end

  def iImage(host = true)
    if host
      if Rails.env.production?
        return image.url(:host => "https://www.mightbuy.it") if image
        "https://www.mightbuy.it/assets/no_image.png"
      else
        return image.url(:host => "http://localhost:3000") if image
        "https://www.mightbuy.it/assets/no_image.png"
      end
    else
      image ? image.url : "https://www.mightbuy.it/assets/no_image.png"
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