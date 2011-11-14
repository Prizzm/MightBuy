require 'spec_helper'

describe "Deals" do

  # deal ->
  #   brand -> belongs
  #   for -> polymorphic
  #   title: string
  #   description: text
  #   low_cost: integer
  #   low_value: decimal
  #   high_cost: integer
  #   high_value: decimal
  #   value_type: (percent dollar etc)
  # 
  # redemption:
  #   deal: belongs
  #   user: belongs
  #   cost: integer
  #   value: integer
  
  describe Points::Bank do
    it { should have_many(:redemptions).class_name("Deals::Redemption") }
  end
  
  describe Brand do
    it { should have_many(:deals).class_name("Deals::Deal") }
  end

  describe Deals::Deal do
    
    it { should belong_to(:brand) }
    it { should belong_to(:for) }
    it { should have_many(:redemptions).class_name("Deals::Redemption") }
    
    it "should have the right table name" do
      subject.class.table_name.should == "deal_deals"
    end
    
  end
  
  describe Deals::Redemption do
    
    it { should belong_to(:deal) }
    it { should belong_to(:bank).class_name("Points::Bank") }
    
    it "should have the right table name" do
      subject.class.table_name.should == "deal_redemptions"
    end
    
  end
  
  describe "purchasing" do
    
    before { @bank = Factory(:bank, :available => 100, :total => 100) }
    
    context "on a fixed deal" do
      
      before do
        @deal = Factory :deal, \
          :low_cost => 100, :low_value => 10.00,
          :high_cost => 0, :high_value => nil,
          :value_type => "dollar"
      end
      
      it "should throw an error if the cost is not exact" do
        proc { @deal.redeem(@bank, 99) }.should raise_error(Exceptions::PointsOutsideDealRange)
        proc { @deal.redeem(@bank, 101) }.should raise_error(Exceptions::PointsOutsideDealRange)
      end
      
      it "should not raise an error if the cost is exact" do
        proc{ @deal.redeem(@bank, 100) }.should_not raise_error(Exceptions::PointsOutsideDealRange)
      end
      
      context "on success" do
        
        it "should return a redemption with valid attributes" do
          redemption = @deal.redeem(@bank, 100)
          redemption.should be_a_kind_of(Deals::Redemption)
          redemption.bank.should == @bank
          redemption.deal.should == @deal
          redemption.cost.should == 100
        end
        
      end
      
    end
    
    context "a ranged deal" do
      
      before do
        @deal = Factory :deal, \
          :low_cost => 50, :low_value => 0.10,
          :high_cost => 150, :high_value => 0.30,
          :value_type => "percent"
      end
      
      it "should throw an error if there are insufficient available points" do
        @bank.available = 35
        proc { @deal.redeem(@bank, 50) }.should raise_error(Exceptions::InsufficientPoints)
      end
      
      it "should throw an error if a redemption is attempted outside of the low to high range" do
        @bank.available = 500
        proc{ @deal.redeem(@bank, 49) }.should raise_error(Exceptions::PointsOutsideDealRange)
        proc{ @deal.redeem(@bank, 151) }.should raise_error(Exceptions::PointsOutsideDealRange)
      end
      
      context "on success" do
        
        it "should subtract the correct amount of points" do
          proc { @deal.redeem(@bank, 50).should change(@bank, :available).by(-50) }
        end
        
        it "should return a redemption with valid attributes" do
          redemption = @deal.redeem(@bank, 50)
          redemption.should be_a_kind_of(Deals::Redemption)
          redemption.bank.should == @bank
          redemption.deal.should == @deal
          redemption.cost.should == 50
        end
        
        it "should assign the correct cost-to-value ratio" do
          cost_to_value = { 50 => 0.1, 75 => 0.15, 100 => 0.2, 130 => 0.26, 150 => 0.3 }
          cost_to_value.each do |points, value|
            @bank.available = 200
            @deal.redeem(@bank, points).value.should == value
          end
        end
        
      end
      
    end
    
  end
  
end