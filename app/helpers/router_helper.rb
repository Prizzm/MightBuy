module RouterHelper
  
  def beta_join_content
    [ "Hey thanks! You\\'re on the list!", 
      link_to("Why not click here & invite a few friends too?", 'http://www.prizzm.com', :target => "_blank")
    ].join("<br />").html_safe
  end
  
end