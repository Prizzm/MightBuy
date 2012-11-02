require "spec_helper"

describe User, "authenticating using facebook" do
  it "should create user with email given correct response" do
    user = User.from_omniauth(auth_hash)
    user.should_not be_nil
    user.email.should == "hemant@example.com"
    user.image.should_not be_nil
  end

  it "should create slug for URL" do
    user = User.create(:email => "test@example.com", :name => "Fname Lname")
    user.should_not be_nil
    user.slug.should_not be_nil
  end

  describe "#popular_tags" do
    let(:tyler)  { FactoryGirl.create(:user) }

    let(:shoes)  { FactoryGirl.create(:tag) }
    let(:bags)   { FactoryGirl.create(:tag) }
    let(:cars)   { FactoryGirl.create(:tag) }

    let(:nike)   { FactoryGirl.create(:topic) }
    let(:fiat)   { FactoryGirl.create(:topic) }

    before(:each) do
      [shoes, bags, cars]

      nike.tags << shoes
      fiat.tags << cars
    end

    context "when no topics" do
      it "returns no tags" do
        tyler.popular_tags.should be_empty
      end
    end

    context "when topics have no tags" do
      before(:each) { FactoryGirl.create(:topic, user: tyler) }

      it "returns no tags" do
        tyler.popular_tags.should be_empty
      end
    end

    context "when topics with tags" do
      let(:adidas) { FactoryGirl.create(:topic, user: tyler) }
      let(:ford)   { FactoryGirl.create(:topic, user: tyler) }
      before(:each) do
        adidas.tags << shoes
        ford.tags << cars
      end

      it "returns associated tags" do
        tyler.popular_tags.should =~ [shoes, cars]
      end

      context "when shoes tag is more popular" do
        let(:reebok)  { FactoryGirl.create(:topic, user: tyler) }
        before(:each) { reebok.tags << shoes }

        it "returns associated tags" do
          tyler.popular_tags.should =~ [shoes, cars]
        end

        it "returns shoes as more popular tag" do
          tyler.popular_tags.first.should == shoes
        end
      end

      context "when cars tag is more popular" do
        let(:audi)  { FactoryGirl.create(:topic, user: tyler) }
        before(:each) { audi.tags << cars }

        it "returns associated tags" do
          tyler.popular_tags.should =~ [shoes, cars]
        end

        it "returns cars as more popular tag" do
          tyler.popular_tags.first.should == cars
        end
      end
    end
  end
end
