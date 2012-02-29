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
  validates :body, :presence => true
  
  # Uploaders
  image_accessor :image
  
  # Nested Attributes
  accepts_nested_attributes_for :shares,
    :reject_if => proc { |attributes| attributes["with"].blank? }
  
  # Attributes
  attr_accessor :pass_visitor_code
  
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