class Topic < ActiveRecord::Base
  
  # Includes
  include InheritUpload
  
  # Options
  Access = {
    "Anyone." => "public",
    "Only by Invite." => "private"
  }
  
  # Relationships
  has_many :responses
  has_many :shares, :class_name => "Shares::Share", :inverse_of => :topic
  belongs_to :user
  
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

  # Nested Attributes
  accepts_nested_attributes_for :shares,
    :reject_if => proc { |attributes| attributes["with"].blank? }
  
  # Attributes
  attr_accessor :pass_visitor_code
  
  def displayPrice
    if self.price then
      return "for #{self.price}"
    else
      return ""
    end
  end
  
  def iImage(host = true)
    # Check if mobile image exists
    if self.mobile_image_url then
      # If a mobile image exists then return mobile_image_url
      # https://s3.amazonaws.com/prizzm-invites/images/9271954A-0F0A-4579-AE5D-D53199B154C2.png
      return self.mobile_image_url
    # If not check if image exists
    elsif self.image then
      # Check if host is true
      if host == true then
        # Return image.url with host
        # http://mightbuy.it/topics/43P16H
        return self.image.url(:host => "http://mightbuy.it")
      else
        # Other image.url without host (Path Only)
        # /topics/43P16H
        return self.image.url
      end
    # If nothing exists return nil
    else
      # nil
      return nil
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