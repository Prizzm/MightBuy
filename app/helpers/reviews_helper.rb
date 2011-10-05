module ReviewsHelper
  
  def meta
    super \
      :title => "%s by %s" % [ parent.name, brand.name ],
      :desc  => "I recently bought a %s by %s. Take a look!" % [ parent.name, brand.name ],
      :image => parent.image.thumb
  end
  
end