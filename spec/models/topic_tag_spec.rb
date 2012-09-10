require 'spec_helper'

describe TopicTag do
  it {
    should validate_presence_of(:tag_id)
    should validate_presence_of(:topic_id)
  }
end
