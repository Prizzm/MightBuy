require 'spec_helper'

describe SearchController do

  describe "GET 'public'" do
    it "returns http success" do
      get 'public'
      response.should be_success
    end
  end

end
