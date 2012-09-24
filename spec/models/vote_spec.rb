require 'spec_helper'

describe Vote do
  it { should validate_presence_of(:topic) }
end
