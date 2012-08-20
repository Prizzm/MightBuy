require 'spec_helper'

Points.allocators do
  add :facebook_like, 30
  add :twitter_message, 50
end

describe "Points" do
  
  describe Points::Bank do
    it "should have the right table name" do
      subject.class.table_name.should == "point_banks"
    end
    
    it { should belong_to(:bankable) }
    it { should have_many(:allocations).class_name("Points::Allocation") }
  end

  describe Points::Allocation do
    it "should have the right table name" do
      subject.class.table_name.should == "point_allocations"
    end
    
    it "should only allow valid allocator names" do
      subject.bank = Factory(:bank)
      subject.allocator = nil
      subject.should_not be_valid
      subject.allocator = :something_wrong
      subject.should_not be_valid
      subject.allocator = :facebook_like
      subject.should be_valid
    end
    
    it { should belong_to(:bank).class_name("Points::Bank") }
    it { should belong_to(:allocatable) }
    it { should validate_presence_of(:lookup) }
    # it { should validate_uniqueness_of(:lookup) }
  end
  
  context "bank" do
    subject { Factory(:bank) }
    
    it "should by default have no total points" do
      subject.total.should == 0
    end
    
    it "should by default have no available points" do
      subject.available.should == 0
    end
    
    context "adding points" do
      
      it "should update the total amount" do
        proc { subject.add :facebook_like }.should change(subject, :total).by(30)
      end
      
      it "should update the available amount" do
        proc { subject.add :facebook_like }.should change(subject, :total).by(30)
      end
      
      it "should not allow the same allocator to give out points more than once" do
        product = Factory(:product)
        proc { subject.add! :facebook_like, :allocatable => product }.should change(subject, :available).by(30)
        proc { subject.add! :facebook_like, :allocatable => product }.should_not change(subject, :available)
        subject.allocations.count.should == 1
      end
      
      it "should add an allocation" do
        user = Factory(:user)
        subject.add :facebook_like, :allocatable => user
        allocation = subject.allocations.last
        allocation.allocator.should == "facebook_like"
        allocation.allocatable.should == user
        allocation.points.should == 30
      end
      
    end
    
    context "spending points" do
      
      before do
        subject.total = 200
        subject.available = 100
      end
      
      it "should do nothing to the total amount" do
        proc { subject.spend 50 }.should_not change(subject, :total)
      end
      
      it "should update the available amount" do
        proc { subject.spend 100 }.should change(subject, :available).by(-100)
      end
      
      it "should throw an error if not enough points are available" do
        proc { subject.spend(101) }.should raise_error(Exceptions::InsufficientPoints)
      end
      
      it "should add an allocation" do
        user = Factory(:user)
        subject.spend(50)
        allocation = subject.allocations.last
        allocation.allocator.should == :spent
        allocation.points.should == -50
      end
      
    end
  end
  
  context "has inclusion" do
  
    before { User.send :include, Points::Has }
    
    subject { Factory(:user) }
    
    it { should have_one(:bank).class_name("Points::Bank") }
    
    context "points accessor" do
      
      it "should instantiate & return a bank object if none exists" do
        subject.bank = nil
        subject.points.should be_a_kind_of(Points::Bank)
      end
      
    end
  
  end
  
end