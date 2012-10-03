module BrandsHelper
  
  def header
    case action_name
      when :index then "Our Brands.."
      else super
    end
  end
  
end