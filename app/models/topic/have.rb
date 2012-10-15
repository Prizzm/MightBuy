module Topic::Have
  extend ActiveSupport::Concern

  module ClassMethods

  end

  def human_status
    ihave? ? "has" : "mightbuy"
  end

  def ihave?
    status == "ihave"
  end
end
