require 'digest/sha1'

module Points
  
  def self.allocators (&block)
    @allocators ||= Allocators.new
    @allocators.instance_eval(&block) if block_given?
    @allocators
  end
  
  class Allocators < Hash
    def add (id, points)
      self[id] = points
    end
  end
  
  module Has
    extend ActiveSupport::Concern
    
    included do
      has_one :bank, :as => :bankable, :class_name => "Points::Bank"
    end
    
    def points
      bank || build_bank
    end
  end
  
  module Lookup
    
    def self.for (bank = nil, allocator = nil, allocatable = nil)
      if bank && allocator
        array = [bank.id, allocator]
        array.push(allocatable.id, allocatable.class) if allocatable
        Digest::SHA1.hexdigest array.join('/')
      end
    end
    
    def self.for_allocation (allocation)
      self.for(allocation.bank, allocation.allocator, allocation.allocatable)
    end
    
  end
  
  class Bank < ActiveRecord::Base
    
    include Deals::Model
    self.table_name = "point_banks"

    has_many :allocations, :class_name => "Points::Allocation", :after_add => :increment_awarded!
    belongs_to :bankable, :polymorphic => true
    
    def add (allocator, attributes = {})
      allocation = Allocation.new attributes.merge(
        :bank => self,
        :allocator => allocator, 
        :points => Points.allocators[allocator]
      )
        
      if allocation.valid?
        self.total += allocation.points
        self.available += allocation.points
        allocations.push(allocation)
      end
    end
    
    def add! (*args)
      add *args ; save
    end
    
    def spend (points, attributes = {})
      raise Exceptions::InsufficientPoints.new if points > available
      self.available -= points
      allocations.build attributes.merge(
        :allocator => :spent, :points => -points)
    end
    
    def spend! (*args)
      spend *args ; save
    end
    
    def awarded
      @awarded ||= 0
    end
    
    private
    
      def increment_awarded! (allocation)
        awarded
        @awarded += allocation.points
      end
    
  end
  
  class Allocation < ActiveRecord::Base
    self.table_name = "point_allocations"
    
    # Relationships
    belongs_to :bank, :class_name => "Points::Bank"
    belongs_to :allocatable, :polymorphic => true
    
    # Validations
    validates :lookup, :uniqueness => true, :presence => true
    
    validate do
      unless Points.allocators.keys.include?(allocator)
        errors.add(:allocator, "must be a valid allocator name") 
      end
    end
    
    # Filters
    before_validation do
      self.lookup = Lookup.for_allocation(self)
    end
    
    # Methods
    
    def self.lookup_exists? (lookup)
      exists?(:lookup => lookup)
    end
    
  end
  
end

# Allocators
Points.allocators do
  add :starting_a_topic, 10
  add :uploading_a_photo, 30
  add :responding, 20
  add :joining, 40
  add :tweeting, 150
  add :recommending, 150
  add :giving_more_feedback, 60
  add :registering, 30
end