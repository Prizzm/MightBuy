module BrandsHelper
  
  def header
    case action_name
      when :show then "%s - Welcome!" % resource.name
      else super
    end
  end
  
  def quick_links
    case action_name
      when :index then nil
      when :show then link_for(:back)
      else super
    end
  end
  
end