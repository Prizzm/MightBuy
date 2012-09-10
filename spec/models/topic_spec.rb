require 'spec_helper'

describe Topic do
  it {
    should validate_presence_of(:subject)
  }

  describe "returning topic image thumbnail" do
    it "should return image of appropriate thumbnail" do
      topic = FactoryGirl.create(:topic)
      topic.thumbnail_image.should == "/assets/no_image.png"
    end
  end
end
