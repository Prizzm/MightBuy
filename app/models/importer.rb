module Importer
  
  require 'csv'
  
  def self.csv (file, topic)
    CSV.parse(file.read) do |line|
      Shares::Email.new(:with => line[0], :topic => topic).tap do |share|
        topic.shares << share if share.valid?
      end
    end
  end
  
end