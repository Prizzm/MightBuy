module Deals
  
  VALUE_TYPES = {
    "(%) Percentage" => "percent",
    "($) Dollar Amount" => "dollar"
  }
  
  
  module Model
    extend ActiveSupport::Concern
    
    included do
      if self == User
        has_many :deals, :class_name => "Deals::Deal"
      elsif self == Points::Bank
        has_many :redemptions, :class_name => "Deals::Redemption"
      else
        has_many :redemptions, :class_name => "Deals::Redemption", :as => :for
      end
    end
  end
  
  class Deal < ActiveRecord::Base
    self.table_name = "deal_deals"

    has_many :redemptions, :class_name => "Deals::Redemption"
    belongs_to :user
    belongs_to :for, :polymorphic => true
    
    def redeem! (*args)
      redeem(*args) ; save
    end
    
    def redeem (bank, points)
      if points != low_cost && (points < low_cost || points > high_cost)
        raise Exceptions::PointsOutsideDealRange 
      else
        if bank.spend(points)
          redemptions.build \
            :bank => bank,
            :cost => points,
            :value => value_of_points(points)
        end
      end
    end
    
    private
    
      def value_of_points (points)
        lc, hc = low_cost.to_f, high_cost.to_f
        lv, hv = low_value.to_f, high_value.to_f
        ratio = ((points.to_f - lc) / (hc - lc)).round(2)
        value = (((hv - lv) * ratio) + lv).round(2)
      end
    
  end
  
  class Redemption < ActiveRecord::Base
    
    self.table_name = "deal_redemptions"
    
    belongs_to :deal
    belongs_to :bank, :class_name => "Points::Bank"
    
  end
  
end