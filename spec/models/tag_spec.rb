require 'spec_helper'

describe Tag do
  it {
    should validate_presence_of(:name)
  }

  it "should return most popular tags" do
    tags = [FactoryGirl.create(:tag), FactoryGirl.create(:tag)]
    topics = []
    5.times do
      topic = FactoryGirl.create(:topic)
      topic.tags << tags[i]
    end
  end
end

