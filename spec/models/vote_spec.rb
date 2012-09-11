require 'spec_helper'

describe Vote do
  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:user)  }
end
