module JavascriptHelper
  
  # Shorthand to escape javascript & encapsulate in string.
  def e (object)
    ("'%s'" % escape_javascript(object.to_s)).html_safe
  end
  
  # Shorthand to convert a ruby object to javascript.
  def js (object)
    object.to_json.html_safe
  end
  
end