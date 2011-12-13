class Topic < ActiveRecord::Base

  # Options
  Access = {
    "Anyone." => "public",
    "Only by Invite." => "private"
  }
  
  # Relationships
  has_many :responses
  has_many :shares, :class_name => "Shares::Share"
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
  mount_uploader :image, TopicImageUploader
  
  # Nested Attributes
  accepts_nested_attributes_for :shares
  
  def post?
    !question?
  end
  
  def question?
    subject[/\?\s*$/i] ? true : false
  end
  
  def to_param
    shortcode
  end
  
  def stats
    @stats ||= {}.tap do |hash|
      total_shares       = shares.count
      total_responses    = responses.count
      total_recommends   = responses.where(:recommended => true).count
      unique_shares      = shares.group(:with).count.inject(0) { |count, item| count + item[1] }
      unique_responses   = responses.group(:share_id).where("share_id is not null").
                              count.inject(0) { |count, item| count + item[1] }
      
      hash[:shares] = total_shares
      hash[:responses] = total_responses
      hash[:share_responses] = unique_responses
      hash[:response_rate] = "%s%" % ((unique_responses.to_f / unique_shares.to_f) * 100).to_i rescue 0
      hash[:recommends] = total_recommends
      hash[:recommendation_rate] = "%s%%" % ((total_recommends.to_f / total_responses.to_f) * 100).to_i rescue 0
    end
  end
  
end