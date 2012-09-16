require 'spec_helper'

describe Tag do

  describe "should checks" do
    before {
      @tag = FactoryGirl.create(:tag)
    }
    it {
      should validate_presence_of(:name)
      should validate_uniqueness_of(:name)
    }
  end

  it "should return most popular tags" do
    create_topic_with_tags
    popular_tags = Tag.popular_tags()
    popular_tags.first.should == @tags.first
    popular_tags.second.should == @tags.second
  end
end

