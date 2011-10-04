module Brands::BaseHelper
  
  def link (object)
    case object
      when Product then link_to object.name, brands_product_path(object)
      else super(object)
    end
  end
  
end