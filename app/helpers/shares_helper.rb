module SharesHelper
  
  def header
    "Share This With Someone!"
  end
  
  def quick_links
    link_to("Go Back", topic_path(parent), :class => "button")
  end
  
end